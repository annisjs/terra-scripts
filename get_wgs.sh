#!/bin/bash
WGS="gs://working-set-redeposit/wgs/wgs_v4_202408"
echo "Downloading WGS data to workspace"
gsutil -u $GOOGLE_PROJECT -m cp -r $WGS $HOME