#!/bin/bash

echo "Calculating avg depth by site: $(date)"
vcftools --gzvcf 01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.filt.subset.vcf.gz --site-mean-depth --stdout \
	| gzip -c > 03_Results/02_Filtered/Ulithi23_ULFMv1.pop.allsites.subset.vcf.ldepth.gz

echo "Calculating avg depth per individual: $(date)"
vcftools --gzvcf 01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.filt.subset.vcf.gz --depth  --stdout \
	| gzip -c > 03_Results/02_Filtered/Ulithi23_ULFMv1.pop.allsites.subset.vcf.idepth.gz

echo "Calculating avg missingness per individual: $(date)"
vcftools --gzvcf 01_Data/02_Filtered/Ulithi23_ULFMv1.pop.allsites.filt.subset.vcf.gz --missing-indv --stdout \
	| gzip -c > 03_Results/02_Filtered/Ulithi23_ULFMv1.pop.allsites.subset.vcf.imiss.gz
