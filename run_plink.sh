#!/bin/bash
BFILE="${1:-$HOME/megachip/megaex_BestOfMultipleCalls_v2}"
OUTPUT="${2:-output}"
SNP_FILE="${3:-snp.txt}"
plink --recodeA --bfile $BFILE --out $OUTPUT --extract $SNP_FILE -d !

