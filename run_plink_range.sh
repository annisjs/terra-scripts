#!/bin/bash
BFILE="${1:-$HOME/megachip/megaex_BestOfMultipleCalls_v2}"
OUTPUT="${2:-output}"
SNP_FILE="${3:-snp.txt}"
plink --recode A --bfile $BFILE --out $OUTPUT --extract range $SNP_FILE -d !

