#!/bin/bash

# Check if filename argument is provided
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

# Clear output file or create it if it doesn't exist
> "$output_file"

# Read each line of the file and pass it as a parameter
while IFS= read -r line; do
    # Print each line (replace this with your desired command)
    result=$(./call_to_position.sh $line)
    if [ -n "$result" ]; then
        echo "$result:$line" >> "$output_file"
        echo "$result:$line"
    fi
done < "$input_file"