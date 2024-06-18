./get_exome.sh &&
./get_mega.sh &&
./get_install_plink.sh &&
./get_install_cmake.sh &&
mkdir /home/jupyter/exome_output
mkdir /home/jupyter/mega_output
./run_plink_pipeline.sh /home/jupyter/terra-scripts/snp.txt /home/jupyter/exome_output/exome_output exome n &&
./run_plink_pipeline.sh /home/jupyter/terra-scripts/snp.txt /home/jupyter/mega_output/mega_output mega n &&
Rscript setup_phewas.R &&
nohup Rscript run_phewas.R &