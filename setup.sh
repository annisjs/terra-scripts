echo "Creating directory: /home/jupyter/mega_output"
mkdir /home/jupyter/mega_output
echo "\nCreating directory: /home/juypyter/exome_output"
mkdir /home/jupyter/exome_output
./get_mega.sh
./get_exome.sh
./get_install_plink.sh
./get_install_cmake.sh
