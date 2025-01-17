#!/bin/bash
if [ $# -ne 3 ]; then
    echo "Usage: $0 <snp_file> <type (mega or exome)> <file_type (pos/snp)>"
    printf "\nsnp_file: a text file containing the SNPs of interest. If using positions instead of calls, set file_type = pos. Otherwise, set file_type = snp."
    printf "\n\ntype: mega or exome. Should plink be run on mega or exome data. Ensure get_mega or get_exome has been run first."
    printf "\n\npos: is snp_file.txt a position file, call file, or range file.\n"
    exit 1
fi
SNP_FILE=$1
TYPE=$2
POS=$3
POS_FILE=$SNP_FILE
if [ "$POS" = "snp" ]; then
    echo "Creating position file snp_pos.txt from $SNP_FILE"
    ./call_to_position_file.sh $SNP_FILE /home/jupyter/snp_pos.txt
    POS_FILE=/home/jupyter/snp_pos.txt
fi
if [ "$POS" = "pos" ]; then
    echo "$SNP_FILE will be used as a position file"
fi
if [ "$TYPE" = "exome" ]; then
    OUTPUT=/home/jupyter/exome_output/exome_output
    BFILE=/home/jupyter/exomechip/exomechip_001/redeposit_plink_postqc/postQC_redeposit_exomechip_001_v1_202306
    if [ "$POS" = "range" ]; then
        for i in /home/jupyter/exomechip/exomechip_*; do
            if [ -d "$i" ]; then
                bed_file=$(find "$i/redeposit_plink_postqc" -name "*.bed")
                if [ -f "$bed_file" ]; then
                    bed_name="${bed_file%.bed}"
                    echo "Using $bed_name as input to plink"
                    id=$(basename $i)
                    ./run_plink_range.sh $bed_name "$OUTPUT"_"$id" $POS_FILE
                fi
            fi
        done
    fi
    if [ "$POS" = "pos" ]; then
        ./call_from_bim.sh $POS_FILE $BFILE.bim /home/jupyter/snp_call_$TYPE.txt &&
        ./make_snp_file.sh /home/jupyter/snp_call_$TYPE.txt /home/jupyter/snp_out_$TYPE.txt &&
        for i in /home/jupyter/exomechip/exomechip_*; do
            if [ -d "$i" ]; then
                bed_file=$(find "$i/redeposit_plink_postqc" -name "*.bed")
                if [ -f "$bed_file" ]; then
                    bed_name="${bed_file%.bed}"
                    echo "Using $bed_name as input to plink"
                    id=$(basename $i)
                    ./run_plink.sh $bed_name "$OUTPUT"_"$id" /home/jupyter/snp_out_$TYPE.txt
                fi
            fi
        done
        Rscript format_exome_raw.R
    fi

fi

if [ "$TYPE" = "mega" ]; then
    OUTPUT=/home/jupyter/mega_output/mega_output
    BFILE=/home/jupyter/megachip/megaex_BestOfMultipleCalls_v2
    ./call_from_bim.sh $POS_FILE $BFILE.bim /home/jupyter/snp_call_$TYPE.txt &&
    ./make_snp_file.sh /home/jupyter/snp_call_$TYPE.txt /home/jupyter/snp_out_$TYPE.txt &&
    ./run_plink.sh $BFILE $OUTPUT /home/jupyter/snp_out_$TYPE.txt
    Rscript format_mega_raw.R
fi