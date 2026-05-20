#!/bin/bash

#SBATCH --partition=main # Partition (job queue) 
#SBATCH --export=ALL # Export current environment variables to the launched application
#SBATCH --nodes=1 # Number of nodes 
#SBATCH --ntasks=1 # Number of tasks (usually=cores) on each node
#SBATCH --cpus-per-task=1 # Cores per task (>1 if multithread tasks)
#SBATCH --output=/scratch/eec72/Ulithi23/03_STDOUT/set_intervals.out # STDOUT output file (will also contain STDERR if --error is not specified)
#SBATCH --mem=1G # Real memory (RAM) per node required (MB) 
#SBATCH --time=12:00:00 # Total run time limit (HH:MM:SS) 
#SBATCH --job-name=set_intervals  # Replace with your jobname

cd /scratch/eec72/Ulithi23

module use /projects/community/modulefiles
module load gatk/4.4.0-bd387

# Create necessary reference.dict index file for gatk to parse reference fasta

# Only run once
#gatk CreateSequenceDictionary \
#      -R 00_resources/Montipora_sp1_aff_capitata_ULFMv1.assembly.fasta \
#      -O 00_resources/Montipora_sp1_aff_capitata_ULFMv1.assembly.fasta.dict

gatk SplitIntervals \
      -R 00_resources/Montipora_sp1_aff_capitata_ULFMv1.assembly.fasta \
      -L 00_resources/scaffold_names.list \
      --scatter-count 100 \
      --subdivision-mode BALANCING_WITHOUT_INTERVAL_SUBDIVISION_WITH_OVERFLOW \
      -O 00_resources/interval_files
