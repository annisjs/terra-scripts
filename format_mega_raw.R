# Setup MEGA genotype file
library(data.table)
library(stringr)
mega_raw_file <- "~/mega_output/mega_output.raw"
mega_call_file <- "~/snp_call_mega.txt"
mega_genotype_output <- "~/mega_output/genotypes.csv"
snps <- data.table::fread(mega_call_file,header=F)
snps$V1 <- sapply(snps$V1, function(x) strsplit(x," ")[[1]][1])
dat_raw <- data.table::fread(mega_raw_file)
colnames(dat_raw) <- gsub("_T|_G|_C|_A|_0","",colnames(dat_raw))
setnames(dat_raw,snps$V2,snps$V1)
dat_raw <- dat_raw[,.SD,.SDcols=c(2,7:ncol(dat_raw))]
names(dat_raw)[1] <- "id"
data.table::fwrite(dat_raw,mega_genotype_output)