# Scripts for running PLINK and installing cmake for PheWAS on Terra
## Set up
1. git clone repository
2. cd into folder
3. Create your SNP text file. One row for each SNP.
4. Run chmod +x *

## PLINK pipeline
1. get_install_plink.sh
2. get_mega.sh
3. get_exome.sh
4. An example would be: ./run_plink_pipeline.sh /home/jupyter/terra-scripts/snp.txt /home/jupyter/exome_output/exome_output exome n
This runs the SNPs in snp.txt using Exome data. Output would be stored in exome_output folder in home folder. 
The "exome" argument tells the script to use exome data and the "n" argument states that the SNP file is a call file (e.g. usually starting "rs").

## PheWAS setup
The PheWAS R package requires cmake.
1. To install cmake run: get_install_cmake.sh.
2. In R, run devtools::install_github("PheWAS/PheWAS",upgrade=F). 
