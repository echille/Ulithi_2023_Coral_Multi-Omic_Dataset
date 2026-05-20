#!/bin/bash

# uses kraken2
# mamba activate kraken2_env

# takes as input path to database and path to trimmed fastq files
cd /scratch/erin/Ulithi23/02.1_symbiont_composition_kraken

make_kraken_report(){
    db=$1
    r1=$2
    f=$(basename "$r1")

    # Infer R2 by swapping ".1.fastq.gz" → ".2.fastq.gz"
    r2=${r1/.1.fastq.gz/.2.fastq.gz}

    echo "R1: $r1"
    echo "R2: $r2"

    # Output file stems (strip ".1.fastq.gz")
    stem=${f%.1.fastq.gz}

    kraken_raw=03_results/01_genome_kraken_out/${stem}.k2_output.txt
    mpa_out=03_results/03_genome_kraken_mpa/${stem}.k2_mpa_report.txt

    printf "Processing %s and %s into %s\n" "$r1" "$r2" "$kraken_raw"

    # Run kraken2: classification output + mpa report
    kraken2 \
        --db "$db" \
        --threads 32 \
        --gzip-compressed \
        --paired \
        --use-mpa-style \
        --output "$kraken_raw" \
        --report "$mpa_out" \
        "$r1" "$r2"
}

# Run sequentially over all *.1.fastq.gz files
for r1 in 01_input/*.1.fastq.gz; do
    make_kraken_report 00_resources/03_kraken_database/ "$r1"
done