#!/bin/bash

#SBATCH --partition=main # Partition (job queue) 
#SBATCH --requeue # Re-run job if preempted
#SBATCH --export=ALL # Export current environment variables to the launched application
#SBATCH --nodes=1 # Number of nodes 
#SBATCH --ntasks=1 # Number of tasks (usually=cores) on each node
#SBATCH --cpus-per-task=1 # Cores per task (>1 if multithread tasks)
#SBATCH --output=/scratch/eec72/Ulithi23/03_STDOUT/bcftools_indiv.%j-%2t.%a.out # STDOUT output file (will also contain STDERR if --error is not specified)
#SBATCH --mem=5G # Real memory (RAM) per node required (MB) 
#SBATCH --time=2:00:00 # Total run time limit (HH:MM:SS) 
#SBATCH --job-name=bcftools  # Replace with your jobname
#SBATCH --array=1-10 # Specify array range

#-----------------------------------------

##### Set environment

cd /scratch/eec72/Ulithi23

module load python/2.7.12
module load intel_mkl/16.0.3
module load bcftools

#------------------------------------------

#### Load list of commands/files into array

index=0

while read line ; do
        index=$(($index+1))
        filearray[$index]="$line"
done < 02_scripts/07_indiv_bcftools_report_array_commands.2.txt

echo "${filearray[$SLURM_ARRAY_TASK_ID]}"

#-------------------------------------------

#### Create function for VCF QC

run_bcftools() {
    vcf="$1"
    f=$(basename "$vcf")

    # Output file stem
    stem=${f%.vcf.gz}

    # Analysis
    bcftools stats -s- -F 00_resources/Montipora_sp1_aff_capitata_ULFMv1.assembly.fasta "${vcf}" > "04_results/01_QC/03_deepvar_QC/${stem}.bcftools_report.txt"
    echo "$(date) – ${stem} complete."
}

#--------------------------------------------

#### Start Analysis

${filearray[$SLURM_ARRAY_TASK_ID]}
