#!/bin/bash

#SBATCH --partition=main-redhat # Partition (job queue) 
#SBATCH --requeue # Re-run job if preempted
#SBATCH --export=ALL # Export current environment variables to the launched application
#SBATCH --nodes=1 # Number of nodes 
#SBATCH --ntasks=1 # Number of tasks (usually=cores) on each node
#SBATCH --cpus-per-task=1 # Cores per task (>1 if multithread tasks)
#SBATCH --output=/scratch/eec72/Ulithi23/03_STDOUT/quickcheck.%j-%2t.%a.out # STDOUT output file (will also contain STDERR if --error is not specified)
#SBATCH --mem=15G # Real memory (RAM) per node required (MB) 
#SBATCH --time=72:00:00 # Total run time limit (HH:MM:SS) 
#SBATCH --job-name=quickcheck  # Replace with your jobname


#-----------------------------------------

#### Set environment

cd /scratch/eec72/Ulithi23

eval "$(conda shell.bash hook)"
conda activate bwamem2_env

#### Run check
echo "Running quickcheck. Will not have an output if file is intact."
samtools quickcheck -v  01_data/03_clean_bam_files/M105-1.clean.bam

echo "Checking header. Will not have an output if file is intact."
samtools view -H 01_data/03_clean_bam_files/M105-1.clean.bam >/dev/null
echo "view_header_exit_code=$?"

echo "Checking full file. Will not have an output if file is intact."
samtools view 01_data/03_clean_bam_files/M105-1.clean.bam >/dev/null
echo "full_view_exit_code=$?"

echo "Done: $(date)."
