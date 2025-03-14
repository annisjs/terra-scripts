OUTPUT="${1:-output}"
RANGE_FILE="${2:-ranges.txt}"
for i in /home/jupyter/exomechip/exomechip_*; do
    if [ -d "$i" ]; then
        bed_file=$(find "$i/redeposit_plink_postqc" -name "*.bed")
        if [ -f "$bed_file" ]; then
            bed_name="${bed_file%.bed}"
            echo "Using $bed_name as input to plink"
            id=$(basename $i)
            plink2 --bfile $bed_name --extract range "$RANGE_FILE" --geno-counts --set-all-var-ids @:# --out "$OUTPUT"_"$id"
        fi
    fi
done