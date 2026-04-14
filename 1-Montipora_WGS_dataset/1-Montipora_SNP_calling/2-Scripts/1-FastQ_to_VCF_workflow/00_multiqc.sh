#!/bin/bash

#SBATCH --partition=main # Partition (job queue) 
#SBATCH --requeue # Re-run job if preempted
#SBATCH --export=ALL # Export current environment variables to the launched application
#SBATCH --nodes=1 # Number of nodes 
#SBATCH --ntasks=1 # Number of tasks (usually=cores) on each node
#SBATCH --cpus-per-task=1 # Cores per task (>1 if multithread tasks)
#SBATCH --output=/scratch/eec72/Ulithi23/03_STDOUT/multiqc_raw.%j-%2t.%a.out # STDOUT output file (will also contain STDERR if --error is not specified)
#SBATCH --mem=5G # Real memory (RAM) per node required (MB) 
#SBATCH --time=3:00:00 # Total run time limit (HH:MM:SS) 
#SBATCH --job-name=multiqc  # Replace with your jobname


#-----------------------------------------

#### Set environment

cd /scratch/eec72/Ulithi23/04_results/01_QC/03_deepvar_QC

eval "$(conda shell.bash hook)"
conda activate multiqc_env

multiqc .
