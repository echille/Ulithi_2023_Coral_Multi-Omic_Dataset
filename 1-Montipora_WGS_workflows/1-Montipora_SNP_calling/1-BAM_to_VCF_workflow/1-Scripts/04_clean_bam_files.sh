#!/bin/bash

#SBATCH --partition=main-redhat
#SBATCH --requeue
#SBATCH --export=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=90G
#SBATCH --time=72:00:00
#SBATCH --job-name=clean_bam
#SBATCH --output=/scratch/eec72/Ulithi23/03_STDOUT/clean_bam.%A.%a.out
#SBATCH --array=1-100

#-----------------------------------------
# Set environment
#-----------------------------------------

cd /scratch/eec72/Ulithi23 || exit 1

eval "$(conda shell.bash hook)"
conda activate bwamem2_env

#-------------------------------------------
# Create function for mapping and mapping QC
#-------------------------------------------

clean_bam() {
    file="$1"
    outdir="$2"

    f="$(basename "$file")"
    stem="${f%.raw.bam}"

    echo "Start ${file} - $(date)"
    set -euo pipefail

    tmpbase="${SLURM_TMPDIR:-/tmp}"
    tmp="${tmpbase}/${USER}/${SLURM_JOB_ID}/${SLURM_ARRAY_TASK_ID:-0}_${stem}"
    mkdir -p "$tmp"

    samtools view -b -h -q 20 -F 0x100 "$file" \
        | samtools sort -m 40G -T "$tmp/${stem}.cs" -O bam -o "${outdir}/${stem}.clean.bam"

	samtools index -b "${outdir}/${stem}.clean.bam"

    echo "$(date) - ${stem} complete."
}

#--------------------------------------------
# Start Analysis (array driver)
#--------------------------------------------

COMMANDS_FILE="02_scripts/04_clean_bam_files_array_commands.txt"

# Grab the command corresponding to this array index
cmd="$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$COMMANDS_FILE")"

if [[ -z "${cmd}" ]]; then
    echo "ERROR: No command found for SLURM_ARRAY_TASK_ID=${SLURM_ARRAY_TASK_ID} in ${COMMANDS_FILE}"
    exit 2
fi

echo "Running task ${SLURM_ARRAY_TASK_ID}: ${cmd}"
eval "$cmd"
