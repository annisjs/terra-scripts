#!/bin/bash
if [ $# -ne 3 ]; then
    echo "Usage: $0 <snp_file> <output_folder> <type (mega or exome)>"
    exit 1
fi
SNP_FILE=$1
OUTPUT=$2
TYPE=$3
./call_to_position_file.sh $SNP_FILE /home/jupyter/snp_pos.txt &&
if [ "$TYPE" = "exome" ]; then
    BFILE=/home/jupyter/exomechip/exomechip_001/redeposit_plink_postqc/postQC_redeposit_exomechip_001_v1_202306
    ./call_from_bim.sh /home/jupyter/snp_pos.txt $BFILE.bim /home/jupyter/snp_call_$TYPE.txt &&
    ./make_snp_file.sh /home/jupyter/snp_call_$TYPE.txt /home/jupyter/snp_out_$TYPE.txt &&
    for i in /home/jupyter/exomechip/exomechip_*; do
        if [ -d "$i" ]; then
            bed_file=$(find "$i/redeposit_plink_postqc" -name "*.bed")
            if [ -f "$bed_file" ]; then
                bed_name="${bed_file%.bed}"
                echo "Using $bed_name as input to plink"
                id=$(basename $i)
                ./run_plink.sh $bed_name $OUTPUT_$id /home/jupyter/snp_out_$TYPE.txt
            fi
        fi
    done
fi

if [ "$TYPE" = "mega" ]; then
    BFILE=/home/jupyter/megachip/megaex_BestOfMultipleCalls_v2
    ./call_from_bim.sh /home/jupyter/snp_pos.txt $BFILE.bim /home/jupyter/snp_call_$TYPE.txt &&
    ./make_snp_file.sh /home/jupyter/snp_call_$TYPE.txt /home/jupyter/snp_out_$TYPE.txt &&
    ./run_plink.sh $BFILE $OUTPUT /home/jupyter/snp_out_$TYPE.txt
fi