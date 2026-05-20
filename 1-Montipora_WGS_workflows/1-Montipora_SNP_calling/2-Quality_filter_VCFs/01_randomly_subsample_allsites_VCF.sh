#!/bin/bash

# mamba activate vcftools_env
# cd /scratch/erin/Ulithi23/03_McapULFMv1_popgen

#random subsample
bcftools view 01_Data/01_Unfiltered/Ulithi23_ULFMv1.pop.allsites.vcf.gz | vcfrandomsample --rate 0.00097230821 --random-seed 124 | bgzip -c > 01_Data/01_Unfiltered/Ulithi23_ULFMv1.pop.allsites.subset.vcf.gz

#index
bcftools index 01_Data/01_Unfiltered/Ulithi23_ULFMv1.pop.allsites.subset.vcf.gz
