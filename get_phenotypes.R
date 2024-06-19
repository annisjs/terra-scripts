devtools::install_github("annisjs/aou.bucket",upgrade=F)
devtools::install_github("PheWAS/PheWAS",upgrade=F)
library(data.table)
library(bigrquery)
library(stringr)
library(aou.bucket)
library(PheWAS)
my_bucket <- Sys.getenv("WORKSPACE_BUCKET")
pull_icd <- TRUE
phenotype_file <- "~/phenotypes.csv"
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
              WHERE vocabulary_id LIKE 'ICD%'"
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