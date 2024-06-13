#!/bin/bash
EXOME="gs://working-set-redeposit/exomechip"
echo "Creating directory $HOME/exomechip"
mkdir $HOME/exomechip
echo "Downloading Exome data to workspace"
gsutil -u $GOOGLE_PROJECT cp -r $EXOME $HOME/exomechip