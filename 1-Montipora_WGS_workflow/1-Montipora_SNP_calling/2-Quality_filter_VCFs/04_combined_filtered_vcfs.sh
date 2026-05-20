#!/bin/bash

#echo "Concatting invariant and variant VCF files $(date)"
bcftools concat \
	--allow-overlaps \
	01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.variant_sites.filt.vcf.gz \
	01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.invariant_sites.filt.vcf.gz \
	-O z -o 01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.filt.vcf.gz

#echo "Filtering again: $(date)"
#vcftools --gzvcf Ulithi23_ULFMv1.pop.allsites.filt.vcf.gz --min-meanDP 10 --max-meanDP 60 --minDP 10 --maxDP 60 --max-missing 0.9 --recode --recode-INFO-all --stdout \
#	| bgzip -c > Ulithi23_ULFMv1.pop.allsites.filt_max60.vcf.gz

echo "Indexing combined VCF $(date)"
bcftools index 01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.filt.vcf.gz

echo "Subsetting combined VCF $(date)"
bcftools view 01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.filt.vcf.gz \
	| vcfrandomsample --rate 0.00141026584 --random-seed 124 \
	| bgzip -c > 01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.filt.subset.vcf.gz

echo "Calculating stats: $(date)"
./02_Scripts/05_stats_filtered_allsites_subset.sh
