#!/bin/bash

# Loop through all matching files
for file in chr*_output.vcf.gz; do
  # Extract the digit(s) following "chr"
  x=$(echo "$file" | grep -oP '(?<=chr)\d+|X')

  # Run the bcftools query command and save the output
  bcftools query -f '%CHROM:%POS:[\t%GT]\n' "$file" > genotypes.txt
  
  # Generate the header and save to header.txt
  echo -e "Variant,$(bcftools query -l "$file" | paste -sd ',')" > header.txt
  
  # Combine header and genotypes.txt into a CSV file
  cat header.txt genotypes.txt | tr '\t' ',' > "chr${x}_genotypes.csv"
  
  # Clean up intermediate files
  rm genotypes.txt header.txt
done

echo "Processing complete. CSV files generated for all matching VCF files."
