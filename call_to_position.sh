#!/bin/bash
SNP=$1
xml_response=$(curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=SNP&id=$SNP")
echo "$xml_response" | grep -oP '(?<=<CHRPOS_PREV_ASSM>).*?(?=</CHRPOS_PREV_ASSM>)' |  sed 's/.*://'