#!/bin/bash

#SBATCH --partition=main
#SBATCH --requeue
#SBATCH --export=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --time=1:00:00
#SBATCH --job-name=dv_to_gatk
#SBATCH --output=/scratch/eec72/Ulithi23/03_STDOUT/dv_to_gatk.%A.%a.out
#SBATCH --array=1-100

#-----------------------------------------
# Set environment
#-----------------------------------------

cd /scratch/eec72/Ulithi23

module use /projects/community/modulefiles
module load bcftools

eval "$(conda shell.bash hook)"
conda activate bwamem2_env

#-------------------------------------------
# Create function to make a GATK GenomicDB for each interval
#-------------------------------------------

dv_to_gatk() {
    file="$1"

    f="$(basename "$file")"
    stem="${f%.gvcf.gz}"

    echo "Starting analysis for ${file}"
    set -euo pipefail

    zcat "${file}" \
        | sed -e 's/<\*>/<NON_REF>/g' \
        | bgzip -c > "01_data/04_vcf_files/${stem}.gatkcompliant.gvcf.gz" \
        && bcftools index -t "01_data/04_vcf_files/${stem}.gatkcompliant.gvcf.gz"
         
    echo "$(date) - ${stem} complete."
}

#--------------------------------------------
# Start Analysis (array driver)
#--------------------------------------------

COMMANDS_FILE="02_scripts/09_convert_gvcfs_to_gatk_compliant_format_array_commands.txt"

# Grab the command corresponding to this array index
cmd="$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$COMMANDS_FILE")"

if [[ -z "${cmd}" ]]; then
    echo "ERROR: No command found for SLURM_ARRAY_TASK_ID=${SLURM_ARRAY_TASK_ID} in ${COMMANDS_FILE}"
    exit 2
fi

echo "Running task ${SLURM_ARRAY_TASK_ID}: ${cmd}"
eval "$cmd"
