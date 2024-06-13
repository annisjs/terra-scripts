#!/bin/bash
MEGA="gs://working-set-redeposit/megaex/megaex_000_a_v2/redeposit_plink_best_calls/*"
echo "Creating directory $HOME/megachip"
mkdir $HOME/megachip
echo "Downloading MEGA data to workspace"
gsutil -u $GOOGLE_PROJECT cp $MEGA $HOME/megachip