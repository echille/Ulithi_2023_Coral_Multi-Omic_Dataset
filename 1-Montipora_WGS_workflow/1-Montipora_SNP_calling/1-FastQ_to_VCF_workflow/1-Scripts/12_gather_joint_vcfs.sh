#!/bin/bash

#SBATCH --partition=main # Partition (job queue) 
#SBATCH --requeue # Re-run job if preempted
#SBATCH --export=ALL # Export current environment variables to the launched application
#SBATCH --nodes=1 # Number of nodes 
#SBATCH --ntasks=1 # Number of tasks (usually=cores) on each node
#SBATCH --cpus-per-task=1 # Cores per task (>1 if multithread tasks)
#SBATCH --output=/scratch/eec72/Ulithi23/03_STDOUT/gather_gvcfs.out # STDOUT output file (will also contain STDERR if --error is not specified)
#SBATCH --mem=2G # Real memory (RAM) per node required (MB) 
#SBATCH --time=1:00:00 # Total run time limit (HH:MM:SS) 
#SBATCH --job-name=gather_gvcfs  # Replace with your jobname

#-----------------------------------------
# Set environment
#-----------------------------------------

cd /scratch/eec72/Ulithi23 || exit 1

module use /projects/community/modulefiles
module load gatk/4.4.0-bd387

#--------------------------------------------
# Start Analysis
#--------------------------------------------


ls 01_data/06_joint_allsites_vcf_files/*scattered.vcf.gz | sort > 00_resources/vcf_gather.list

gatk GatherVcfs \
  $(awk '{print "-I",$1}' 00_resources/vcf_gather.list) \
  -O 04_results/02_joint_genotype_allsites_vcf/test.joint.allsites.vcf.gz

echo "$(date) - Gather complete."
