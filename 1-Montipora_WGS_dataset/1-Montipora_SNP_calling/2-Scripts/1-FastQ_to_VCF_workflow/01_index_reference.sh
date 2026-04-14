#!/bin/bash

#SBATCH --partition=main # Partition (job queue) 
#SBATCH --requeue # Do not re-run job if preempted
#SBATCH --export=ALL # Export current environment variables to the launched application
#SBATCH --nodes=1 # Number of nodes 
#SBATCH --ntasks=1 # Number of tasks (usually=cores) on each node
#SBATCH --cpus-per-task=1 # Cores per task (>1 if multithread tasks)
#SBATCH --output=/scratch/eec72/Ulithi23/03_STDOUT/index_ref.out # STDOUT output file (will also contain STDERR if --error is not specified)
#SBATCH --mem=12G # Real memory (RAM) per node required (MB) 
#SBATCH --time=72:00:00 # Total run time limit (HH:MM:SS) 
#SBATCH --job-name=index_ref  # Replace with your jobname

cd /scratch/eec72/Ulithi23

eval "$(conda shell.bash hook)"
conda activate bwamem2_env


#bwa-mem2 index 00_resources/Montipora_sp1_aff_capitata_ULFMv1.assembly.fasta
samtools faidx 00_resources/Montipora_sp1_aff_capitata_ULFMv1.assembly.fasta
