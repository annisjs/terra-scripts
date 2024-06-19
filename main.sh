./get_exome.sh &&
./get_mega.sh &&
./get_install_plink.sh &&
./get_install_cmake.sh &&
mkdir /home/jupyter/exome_output &&
mkdir /home/jupyter/mega_output &&
./run_plink_pipeline.sh /home/jupyter/terra-scripts/snp.txt exome n &&
./run_plink_pipeline.sh /home/jupyter/terra-scripts/snp.txt mega n &&
Rscript get_phenotypes.R &&
Rscript run_phewas_exome.R
Rscript run_phewas_mega.R