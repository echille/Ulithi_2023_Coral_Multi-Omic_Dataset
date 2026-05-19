#!/bin/bash

#mamba activate vcftools_env

# create a filtered VCF containing only invariant sites
vcftools --gzvcf 01_Data/01_Unfiltered/Ulithi23_ULFMv1.pop.allsites.vcf.gz --max-maf 0 --recode --stdout | bgzip -c > 01_Data/01_Unfiltered/Ulithi23_ULFMv1.pop.allsites.invariant_sites.vcf.gz

# index
bcftools index 01_Data/01_Unfiltered/Ulithi23_ULFMv1.pop.allsites.invariant_sites.vcf.gz
