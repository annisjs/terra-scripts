library(PheWAS)
phenotypes <- data.table::fread("~/phenotypes.csv",header=T)
mega_genotypes <- data.table::fread("~/mega_output/genotypes.csv")
exome_genotypes <-  data.table::fread("~/exome_output/genotypes.csv")
mega_phewas_output <- "~/mega_output/phewas_output.csv"
exome_phewas_output <- "~/exome_output/phewas_output.csv"
results <- phewas(phenotypes=phenotypes,
                  genotypes=mega_genotypes,
                  significance.threshold=c("bonferroni"),
                  cores=8,
                  additive.genotypes = FALSE)
results <- addPhecodeInfo(results)
data.table::fwrite(results,mega_phewas_output)
results <- phewas(phenotypes=phenotypes,
                  genotypes=exome_genotypes,
                  significance.threshold=c("bonferroni"),
                  cores=8,
                  additive.genotypes = FALSE)
results <- addPhecodeInfo(results)
data.table::fwrite(results,exome_phewas_output)