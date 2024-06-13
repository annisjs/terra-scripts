#!/bin/bash

# Check if filename arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <position_file> <bim_file> <output_file>"
    exit 1
fi

position_file="$1"
bim_file="$2"
output_file="$3"

# Check if input file exists
if [ ! -f "$position_file" ]; then
    echo "Error: Input file '$position_file' not found."
    exit 1
fi

# Check if file to grep exists
if [ ! -f "$bim_file" ]; then
    echo "Error: File to grep '$bim_file' not found."
    exit 1
fi

# Clear output file or create it if it doesn't exist
> "$output_file"

# Read each line of the input file and use it as a parameter for grep
while IFS= read -r line; do
    # Execute grep with the current line as a parameter
    chr=$(echo "$line" | cut -d ':' -f 1)
    pos=$(echo "$line" | cut -d ':' -f 2)
    snp=$(echo "$line" | cut -d ':' -f 3)
    # Use grep with extended regex to find the line that matches the search terms
    result=$(awk -v first="$chr" -v fourth="$pos" '$1 == first && $4 == fourth' "$bim_file")
    echo "$snp    $result" >> $output_file
done < "$position_file"
