library(stringr)
library(data.table)
exome_raw_file <- "~/exome_output/exome_output_exomechip_{x}.raw"
exome_call_file <- "~/snp_call_exome.txt"
exome_genotype_output <- "~/exome_output/genotypes.csv"
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