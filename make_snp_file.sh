#!/bin/bash

# Check if input file is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_file> <output_file>"
    exit 1
fi

input_file="$1"
output_file="$2"

# Check if input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' not found."
    exit 1
fi

# Use awk to extract the 3rd column and write to output file
awk '{print $3}' "$input_file" > "$output_file"