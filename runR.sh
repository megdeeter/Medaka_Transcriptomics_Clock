#!/bin/bash
#SBATCH --job-name=generatecounts_med
#SBATCH --partition=highmem_p
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=300G
#SBATCH --time=48:00:00
#SBATCH --output=/scratch/med68205/transclock/log/batchlog/log.%j
#SBATCH --mail-user=med68205@uga.edu
#SBATCH --mail-type=END,FAIL

cd /scratch/med68205/transclock/log/Rlog #specifies folder where R log files go

ml R/4.3.2-foss-2022b #load the version of R you are using

export R_LIBS=/home/med68205/R/x86_64-pc-linux-gnu-library/4.3 #path to where R packages/libraries are installed

R CMD BATCH ~/Medaka_Transcriptomics_Clock/GenomicFeatures_count_reads_medaka.R #path to R script for generating counts