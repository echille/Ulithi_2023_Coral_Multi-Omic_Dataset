#!/bin/bash

#SBATCH --partition=main-redhat # Partition (job queue) 
#SBATCH --requeue # Re-run job if preempted
#SBATCH --export=ALL # Export current environment variables to the launched application
#SBATCH --nodes=1 # Number of nodes 
#SBATCH --ntasks=1 # Number of tasks (usually=cores) on each node
#SBATCH --cpus-per-task=24 # Cores per task (>1 if multithread tasks)
#SBATCH --output=/scratch/eec72/Ulithi23/03_STDOUT/mapping.%j-%2t.%a.out # STDOUT output file (will also contain STDERR if --error is not specified)
#SBATCH --mem=35G # Real memory (RAM) per node required (MB) 
#SBATCH --time=72:00:00 # Total run time limit (HH:MM:SS) 
#SBATCH --job-name=mapping  # Replace with your jobname
#SBATCH --array=1-100 # Specify array range


#-----------------------------------------

#### Set environment

cd /scratch/eec72/Ulithi23

eval "$(conda shell.bash hook)"
conda activate bwamem2_env

#------------------------------------------

#### Load list of commands/files into array

index=0

while read line ; do
        index=$(($index+1))
        filearray[$index]="$line"
done < 02_scripts/02_mapping_to_host_array_commands.txt

echo "${filearray[$SLURM_ARRAY_TASK_ID]}"

#-------------------------------------------

#### Create function for mapping and mapping QC

map_host_reads() {
    r1=$1
    f=$(basename "$r1")

    # Infer R2 by swapping ".1.fastq.gz" → ".2.fastq.gz"
    r2=${r1/.1.fastq.gz/.2.fastq.gz}

    # Output file stem
    stem=${f%.1.fastq.gz}

    # Align reads to genome, mark duplicate reads, and coordinate-sort
    bwa-mem2 mem -t 24 -a -M \
        00_resources/Montipora_sp1_aff_capitata_ULFMv1.assembly.fasta \
        "$r1" \
        "$r2" \
        | samtools view -@ 24 -S -b > 01_data/02_raw_bam_files/${stem}.raw.bam
 
    echo "$(date) – ${stem} complete."
    }

#--------------------------------------------

#### Start Analysis

${filearray[$SLURM_ARRAY_TASK_ID]}
