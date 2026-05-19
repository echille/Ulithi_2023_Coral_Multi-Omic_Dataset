#!/bin/bash

echo "Filtering invariant sites $(date)"
vcftools --gzvcf 01_Data/01_Unfiltered/Ulithi23_ULFMv1.pop.allsites.invariant_sites.vcf.gz \
	--min-meanDP 10 \
	--max-meanDP 70 \
	--minDP 10 \
	--maxDP 70 \
	--max-missing 0.80 \
	--recode --recode-INFO-all --stdout \
	| bgzip -c > 01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.invariant_sites.filt.vcf.gz

echo "Combine and subset for final stats"
./02_Scripts/04_combined_filtered_vcfs.sh

echo "Done $(date)"
