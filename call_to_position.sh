#!/bin/bash
SNP=$1
xml_response=$(curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=SNP&id=$SNP")

# Check if curl command was successful
if [ $? -ne 0 ]; then
    echo "Failed to retrieve XML data from NCBI."
    exit 1
fi

# Check if xml_response is valid XML
if ! grep -q '<CHRPOS_PREV_ASSM>' <<< "$xml_response"; then
    echo "Invalid XML response or SNP ID not found."
    exit 1
fi

echo "$xml_response" | grep -oP '(?<=<CHRPOS_PREV_ASSM>).*?(?=</CHRPOS_PREV_ASSM>)'