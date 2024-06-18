#!/bin/bash

# Define the URL for the CMake download page
cmake_download_page="https://github.com/Kitware/CMake/releases"

# Get the latest CMake version download link for Linux x86_64
echo "Fetching the latest CMake download link..."
release=$(curl -s $cmake_download_page | grep -oP "/Kitware/CMake/releases/download/v[0-9]+\.[0-9]+\.[0-9]+/cmake-[0-9]+\.[0-9]+\.[0-9]+-linux-x86_64.tar.gz" | head -1)
download_url="https://github.com/$release"

# Check if the download URL was found
if [ -z "$download_url" ]; then
    echo "Failed to retrieve the download link for the latest CMake version."
    exit 1
fi

# Define the target directory and file names
target_dir="$HOME"
output_file="$target_dir/cmake.tar.gz"

# Download the file
echo "Downloading CMake from $download_url..."
curl -L -o "$output_file" "$download_url"

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Failed to download the file."
    exit 1
fi

# Unpack the tarball
echo "Unpacking the file to $target_dir..."
tar -xf "$output_file" -C "$target_dir"

# Check if the unpacking was successful
if [ $? -ne 0 ]; then
    echo "Failed to unpack the file."
    exit 1
fi

# Find the bin directory inside the unpacked folder
cmake_dir=$(tar -tf "$output_file" | head -1 | cut -f1 -d"/")
cmake_bin_dir="$target_dir/$cmake_dir/bin"

# Add the bin directory to the PATH
echo "Exporting the bin directory to PATH..."
export PATH="$cmake_bin_dir:$PATH"

# Print the new PATH for the current session
echo "CMake bin directory added to PATH: $cmake_bin_dir"
echo "Current PATH: $PATH"
