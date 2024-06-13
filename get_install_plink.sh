#!/bin/bash

# Define the base URL for PLINK downloads
BASE_URL="https://www.cog-genomics.org/plink2/"

# Fetch the latest download page and extract the link to the Linux 64-bit version
echo "Fetching the latest PLINK release link..."
PLINK_URL=$(curl -s $BASE_URL | grep -oP 'href="\K[^"]*linux_x86_64[^"]*' | head -1)

# Check if the link was found
if [[ -z $PLINK_URL ]]; then
  echo "Failed to fetch the latest PLINK release link."
  exit 1
fi

# Define variables
PLINK_ZIP=$(basename $PLINK_URL)
PLINK_DIR="plink"

# Download the latest PLINK release
echo "Downloading PLINK from $PLINK_URL..."
wget -q $PLINK_URL -O $PLINK_ZIP

# Unpack the downloaded file
echo "Unpacking PLINK..."
unzip -q $PLINK_ZIP -d $PLINK_DIR

# Clean up the zip file
rm $PLINK_ZIP

# Move the PLINK executable to /usr/local/bin for global access
echo "Exporting PLINK directory to PATH..."
export PATH=$(pwd)/$PLINK_DIR:$PATH

# Verify installation
if command -v plink &> /dev/null
then
    echo "PLINK was installed successfully."
else
    echo "PLINK installation failed."
fi
