#!/bin/bash

echo "Filtering variant sites $(date)"
vcftools --gzvcf 01_Data/01_Unfiltered/Ulithi23_ULFMv1.pop.allsites.variant_sites.vcf.gz \
	--remove-indels \
	--minQ 30 \
	--maf 0.05 \
	--min-meanDP 10 \
	--max-meanDP 70 \
	--minDP 10 \
	--maxDP 70 \
	--max-missing 0.8 \
	--recode --recode-INFO-all --stdout \
	| bgzip -c > 01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.variant_sites.filt.vcf.gz

echo "Checking filtered variant-only stats $(date)"
echo "	-- Running BCFtools stats"
bcftools stats 01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.variant_sites.filt.vcf.gz \
	> 03_Results/02_Filtered/Ulithi23_ULFMv1.pop.allsites.variant_sites.filt.stats.txt

echo "	-- Calculating allele frequency $(date)"
vcftools --gzvcf 01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.variant_sites.filt.vcf.gz --freq2 --max-alleles 2 --stdout \
	| gzip -c > 03_Results/02_Filtered/Ulithi23_ULFMv1.pop.allsites.variant_sites.vcf.frq.gz

echo "	-- Calculating site quality $(date)"
vcftools --gzvcf 01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.variant_sites.filt.vcf.gz --site-quality --stdout \
	| gzip -c > 03_Results/02_Filtered/Ulithi23_ULFMv1.pop.allsites.variant_sites.vcf.lqual.gz

echo "	-- Calculating proportion of missing data per site $(date)"
vcftools --gzvcf 01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.variant_sites.filt.vcf.gz --missing-site --stdout \
	| gzip -c > 03_Results/02_Filtered/Ulithi23_ULFMv1.pop.allsites.variant_sites.vcf.lmiss.gz

echo "	-- Calculating heterozygosity and inbreeding coefficient per individual $(date)"
vcftools --gzvcf 01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.variant_sites.filt.vcf.gz --het --stdout \
	| gzip -c > 03_Results/02_Filtered/Ulithi23_ULFMv1.pop.allsites.variant_sites.vcf.het.gz

echo "Done $(date)"
