#!/bin/bash

#SBATCH --partition=main
#SBATCH --requeue
#SBATCH --export=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=72:00:00
#SBATCH --job-name=deepvariant
#SBATCH --output=/scratch/eec72/Ulithi23/03_STDOUT/deepvariant.%A.%a.out
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=eec72@scarletmail.rutgers.edu
#SBATCH --array=1-99%11

#-----------------------------------------
# Set environment
#-----------------------------------------

# strict bash settings
set -euo pipefail

cd /scratch/$USER/Ulithi23 || exit 1

module load singularity

#-------------------------------------------
# Create function for variant calling
#-------------------------------------------

variant_calling() {
    file="$1"

    f="$(basename "$file")"
    stem="${f%.clean.bam}"

    echo "Starting analysis for ${file}"

    # make directory for intermediate files
    INTERMEDIATE=/scratch/$USER/Ulithi23/deepvariant_tmp/${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}
    mkdir -p "$INTERMEDIATE"
    
    # make temporary file directory for each job to be deleted when job is fin.
    export TMPDIR="${INTERMEDIATE}/tmp"
    mkdir -p "$TMPDIR"

    singularity exec /scratch/eec72/deepvariant_1.4.0.sif \
          run_deepvariant \
              --model_type=WGS \
              --ref /scratch/eec72/Ulithi23/00_resources/Montipora_sp1_aff_capitata_ULFMv1.assembly.fasta \
              --reads "/scratch/eec72/Ulithi23/${file}" \
              --output_vcf "/scratch/eec72/Ulithi23/01_data/04_vcf_files/${stem}.vcf.gz" \
              --output_gvcf "/scratch/eec72/Ulithi23/01_data/04_vcf_files/${stem}.gvcf.gz" \
              --make_examples_extra_args gvcf_gq_binsize=1 \
              --vcf_stats_report true \
              --num_shards "${SLURM_CPUS_PER_TASK}" \
              --intermediate_results_dir "$INTERMEDIATE"

    # Clean up intermediates to avoid filling scratch
    rm -rf "$INTERMEDIATE"

    echo "$(date) - ${stem} complete."
}

#--------------------------------------------
# Start Analysis
#--------------------------------------------

COMMANDS_FILE="02_scripts/06_run_deepvariant_array_commands.txt"

# Grab the command corresponding to this array index
cmd="$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$COMMANDS_FILE")"

if [[ -z "${cmd}" ]]; then
    echo "ERROR: No command found for SLURM_ARRAY_TASK_ID=${SLURM_ARRAY_TASK_ID} in ${COMMANDS_FILE}"
    exit 2
fi

echo "Running task ${SLURM_ARRAY_TASK_ID}: ${cmd}"

# Execute the array-specific command
type variant_calling
echo "CMD from file: [$cmd]"

eval "$cmd"
