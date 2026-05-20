#!/bin/bash

#SBATCH --partition=main
#SBATCH --requeue
#SBATCH --export=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=6:00:00
#SBATCH --job-name=joint_genotyping
#SBATCH --output=/scratch/eec72/Ulithi23/03_STDOUT/joint_genotyping.%A.%a.out
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=eec72@scarletmail.rutgers.edu
#SBATCH --array=1-3

#-----------------------------------------
# Set environment
#-----------------------------------------

cd /scratch/eec72/Ulithi23 || exit 1

module use /projects/community/modulefiles
module load gatk/4.4.0-bd387

#-------------------------------------------
# Create function to joint genotype samples for each interval
#-------------------------------------------

joint_genotype() {
    interval="$1"

    f="$(basename "$interval")"
    stem="${f%.interval_list}"

    echo "Starting analysis for ${interval}"
    set -euo pipefail

    gatk --java-options "-Xmx4g" GenotypeGVCFs \
        -R 00_resources/Montipora_sp1_aff_capitata_ULFMv1.assembly.fasta \
        -V "gendb://01_data/05_genomicsdb_files/${stem}" \
        -all-sites \
        -L ${interval} \
        -O "01_data/06_joint_allsites_vcf_files/${stem}.vcf.gz"
         
    echo "$(date) - ${stem} complete."
}

#--------------------------------------------
# Start Analysis (array driver)
#--------------------------------------------

COMMANDS_FILE="02_scripts/11_GATK_joint_genotyping_array_commands.txt"

# Grab the command corresponding to this array index
cmd="$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$COMMANDS_FILE")"

if [[ -z "${cmd}" ]]; then
    echo "ERROR: No command found for SLURM_ARRAY_TASK_ID=${SLURM_ARRAY_TASK_ID} in ${COMMANDS_FILE}"
    exit 2
fi

echo "Running task ${SLURM_ARRAY_TASK_ID}: ${cmd}"
eval "$cmd"
