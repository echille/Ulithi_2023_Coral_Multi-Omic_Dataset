#!/bin/bash

#cd /scratch/erin/Ulithi23/03_McapULFMv1_popgen

#mamba activate vcftools_env

# create a filtered VCF containing only invariant sites
vcftools --gzvcf 01_Data/01_Unfiltered/Ulithi23_ULFMv1.pop.allsites.vcf.gz --mac 1 --recode --stdout | bgzip -c > 01_Data/01_Unfiltered/Ulithi23_ULFMv1.pop.allsites.variant_sites.vcf.gz

# index
bcftools index 01_Data/01_Unfiltered/Ulithi23_ULFMv1.pop.allsites.variant_sites.vcf.gz
