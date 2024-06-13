BFILE=/home/jupyter/megachip/megaex_BestOfMultipleCalls_v2.bim
SNP_FILE=$1
OUTPUT=$2
./call_to_position.sh $SNP_FILE /home/jupyter/snp_pos.txt
./call_from_bim.sh /home/jupyter/snp_pos.txt $BFILE /home/jupyter/snp_call.txt
./make_snp_file.sh /home/jupyter/snp_call.txt /home/jupyter/snp_mega.txt
./run_plink.sh $BFILE $OUTPUT $SNP_FILE