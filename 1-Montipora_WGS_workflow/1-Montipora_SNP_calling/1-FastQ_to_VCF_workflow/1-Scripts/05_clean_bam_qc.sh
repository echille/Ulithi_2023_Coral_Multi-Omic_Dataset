#!/bin/bash

#SBATCH --partition=main-redhat
#SBATCH --requeue
#SBATCH --export=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=240G
#SBATCH --time=5:00:00
#SBATCH --job-name=clean_bam_qc
#SBATCH --output=/scratch/eec72/Ulithi23/03_STDOUT/clean_bam_qc.%A.%a.out
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

qc_mapping() {
    file="$1"
    outdir="$2"

    f="$(basename "$file")"
    stem="${f%.bam}"

    echo "Starting analysis for ${file}"
    set -euo pipefail

    mkdir -p "$outdir"

    tmpbase="${SLURM_TMPDIR:-/tmp}"
    tmp="${tmpbase}/${USER}/${SLURM_JOB_ID}/${SLURM_ARRAY_TASK_ID:-0}_${stem}"
    mkdir -p "$tmp"

    samtools sort -m 40G -T "$tmp/${stem}.ns" -n -O bam "$file" \
        | samtools fixmate -m - - \
        | samtools sort -m 40G -T "$tmp/${stem}.cs" -O bam - \
        | samtools markdup - "$outdir/${stem}.QC.bam"

    rm -rf "$tmp"

    qualimap bamqc \
        --java-mem-size=8G \
        -bam "$outdir/${stem}.QC.bam" \
        -outdir "$outdir/${stem}_qualimap_report" \
        -outformat HTML

    samtools stats "$outdir/${stem}.QC.bam" > "$outdir/${stem}_samtools_stats.txt"

    rm "$outdir/${stem}.QC.bam"

    echo "$(date) - ${stem} complete."
}

#--------------------------------------------
# Start Analysis (array driver)
#--------------------------------------------

COMMANDS_FILE="02_scripts/05_clean_bam_qc_array_commands.txt"

# Grab the command corresponding to this array index
cmd="$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$COMMANDS_FILE")"

if [[ -z "${cmd}" ]]; then
    echo "ERROR: No command found for SLURM_ARRAY_TASK_ID=${SLURM_ARRAY_TASK_ID} in ${COMMANDS_FILE}"
    exit 2
fi

echo "Running task ${SLURM_ARRAY_TASK_ID}: ${cmd}"
eval "$cmd"
