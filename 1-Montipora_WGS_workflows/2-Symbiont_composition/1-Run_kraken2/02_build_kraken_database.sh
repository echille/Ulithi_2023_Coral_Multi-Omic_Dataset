#!/bin/bash

# uses kraken2
# mamba activate kraken2_env

# move to working directory
cd /scratch/erin/Ulithi23/02.1_symbiont_composition_kraken

#Download built-in bacteria nt database
kraken2-build --download-library bacteria --db 00_database

#Add coral and symbiont genomes
00_references/02_genome_krakenfa -name '*.fa' -print0 | xargs -0 -I{} -n1 kraken2-build --add-to-library {} --db 00_database

#Build database
kraken-build2 --build --threads 4 --db 00_database