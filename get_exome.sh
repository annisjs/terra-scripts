#!/bin/bash
EXOME="gs://working-set-redeposit/exomechip"
echo "Downloading Exome data to workspace"
gsutil -u $GOOGLE_PROJECT -m cp -r $EXOME $HOME