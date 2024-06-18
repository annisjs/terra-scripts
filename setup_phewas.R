devtools::install_github("annisjs/aou.bucket",upgrade=F)
devtools::install_github("PheWAS/PheWAS",upgrade=F)
library(data.table)
library(bigrquery)
library(stringr)
library(aou.bucket)
library(PheWAS)
my_bucket <- Sys.getenv("WORKSPACE_BUCKET")
pull_icd <- TRUE
mega_raw_file <- "~/mega_output/mega_output.raw"
exome_raw_file <- "~/exome_output/exome_output_exomechip_{x}.raw"
mega_call_file <- "~/snp_call_mega.txt"
exome_call_file <- "~/snp_call_exome.txt"
mega_genotype_output <- "~/mega_output/genotypes.csv"
exome_genotype_output <- "~/exome_output/genotypes.csv"
phenotype_file <- "~/phenotypes.csv"
# Setup MEGA genotype file
snps <- data.table::fread(mega_call_file,header=F)
snps$V1 <- sapply(snps$V1, function(x) strsplit(x," ")[[1]][1])
dat_raw <- data.table::fread(mega_raw_file)
colnames(dat_raw) <- gsub("_T|_G|_C|_A|_0","",colnames(dat_raw))
setnames(dat_raw,snps$V2,snps$V1)
dat_raw <- dat_raw[,.SD,.SDcols=c(2,7:ncol(dat_raw))]
names(dat_raw)[1] <- "id"
data.table::fwrite(dat_raw,mega_genotype_output)
# Setup Exome genotype file
folder_vals <- str_pad(1:10,width = 3,side = "left",pad = 0)
snps <- data.table::fread(exome_call_file,header=F)
snps$V1 <- sapply(snps$V1, function(x) strsplit(x," ")[[1]][1])
dat <- lapply(folder_vals,function(x) data.table::fread(str_glue(exome_raw_file)))
for (i in 1:length(dat))
{
    colnames(dat[[i]]) <- gsub("_T|_G|_C|_A|_0","",colnames(dat[[i]]))
}
dat <- do.call(rbind,dat)
setnames(dat,snps$V2,snps$V1)
dat[,nunique := nrow(.SD[!duplicated(.SD)]),.SDcols=grep("rs",colnames(dat),value=T),.(FID)]
dat[,any_na := apply(.SD,1,function(x) any(is.na(x))),.SDcols=grep("rs",colnames(dat),value=T)]
dat[, rm := nunique == 2 & any_na == TRUE]
# There were some non-duplicate rows for the same subject caused by NAs. We remove the rows 
# with the NAs to get the complete data
dat[,nunique := nrow(.SD[!duplicated(.SD)]),.SDcols=grep("rs",colnames(dat),value=T),.(FID)]
dat[,any_na := apply(.SD,1,function(x) any(is.na(x))),.SDcols=grep("rs",colnames(dat),value=T)]
dat[, rm := nunique == 2 & any_na == TRUE]
dat <- dat[rm == FALSE]
# De-duplicate
dat_final <- dat[,.SD,.SDcols=c("FID",grep("rs",colnames(dat),value=T))]
dat_final <- dat_final[!duplicated(dat_final)]
setnames(dat_final,"FID","id")
data.table::fwrite(dat_final,exome_genotype_output)
# Setup phenotype file
if (pull_icd)
{
    query <- "SELECT DISTINCT p.person_source_value as id,
                     p.gender_source_value as sex,
                     x.entry_date as date,
                     x.concept_code as code,
                     x.vocabulary_id
              FROM sd-vumc-tanagra-test.terra_sd_20230831.x_codes x
              INNER JOIN sd-vumc-tanagra-test.terra_sd_20230831.person p ON (x.person_id = p.person_id)
              INNER JOIN sd-vumc-tanagra-test.terra_sd_20230831.x_genotype_result g ON (x.person_id = g.person_id)
              WHERE vocabulary_id LIKE 'ICD%' AND
              platform_id = 30"
    bq_table <- bq_dataset_query("sd-vumc-tanagra-test.terra_sd_20230831", 
                                 query, 
                                 billing = Sys.getenv("GOOGLE_PROJECT"))
    bq_table_save(bq_table, str_glue("{my_bucket}/codes_*.csv"), destination_format = "CSV")
}

codes <- read_bucket("codes_*.csv")
code_count <- codes[,.(count = length(date),
                           vocabulary_id = vocabulary_id[1]),by=.(id,code)]
code_count <- code_count[,c(1,4,2,3)]
dem <- codes[,c("id","sex")]
dem <- dem[!duplicated(dem)]
phenotypes <- createPhenotypes(code_count, aggregate.fun=sum, id.sex=dem)
data.table::fwrite(phenotypes,phenotype_file)