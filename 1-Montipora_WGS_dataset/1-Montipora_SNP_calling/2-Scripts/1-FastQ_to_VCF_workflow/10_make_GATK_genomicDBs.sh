#!/bin/bash

#SBATCH --partition=main
#SBATCH --requeue
#SBATCH --export=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20G
#SBATCH --time=72:00:00
#SBATCH --job-name=make_genomicDB
#SBATCH --output=/scratch/eec72/Ulithi23/03_STDOUT/make_genomicDB.%A.%a.out
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=eec72@rutgers.edu
#SBATCH --array=1-100

#-----------------------------------------
# Set environment
#-----------------------------------------

cd /scratch/eec72/Ulithi23 || exit 1

module use /projects/community/modulefiles
module load gatk/4.4.0-bd387

#-------------------------------------------
# Create function to make a GATK GenomicDB for each interval
#-------------------------------------------

make_genomicDB() {
    interval="$1"

    f="$(basename "$interval")"
    stem="${f%.interval_list}"

    echo "Starting analysis for ${interval}"
    set -euo pipefail

    #Make GenomicDB
    gatk --java-options "-Xmx4g" GenomicsDBImport \
         --sample-name-map 00_resources/sample_map.txt \
         --genomicsdb-workspace-path "01_data/05_genomicsdb_files/${stem}" \
	 --merge-input-intervals \
         -L ${interval}
         
    echo "$(date) - ${stem} complete."
}

#--------------------------------------------
# Start Analysis (array driver)
#--------------------------------------------

COMMANDS_FILE="02_scripts/10_make_GATK_genomicDBs_array_commands.txt"

# Grab the command corresponding to this array index
cmd="$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$COMMANDS_FILE")"

if [[ -z "${cmd}" ]]; then
    echo "ERROR: No command found for SLURM_ARRAY_TASK_ID=${SLURM_ARRAY_TASK_ID} in ${COMMANDS_FILE}"
    exit 2
fi

echo "Running task ${SLURM_ARRAY_TASK_ID}: ${cmd}"
eval "$cmd"
