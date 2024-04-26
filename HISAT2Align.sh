#!/bin/bash
#SBATCH --job-name=HISAT2_align
#SBATCH --partition=highmem_p
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=100G
#SBATCH --time=72:00:00
#SBATCH --output=/scratch/med68205/TRANS_CLOCK_PROCESSING/Alignment/HISAT2/Log/log.%j
#SBATCH --mail-user=med68205@uga.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --array=1-85 

ml HISAT2/3n-20201216-gompi-2022a

OUTDIR="/scratch/med68205/TRANS_CLOCK_PROCESSING/Alignment/HISAT2"

sample_names = $(cat /scratch/med68205/TRANS_CLOCK_PROCESSING/Alignment/HISAT2/sample.names)

for i in $sample_names
do

echo 'Aligning...'

hisat2 -p 12 -x $OUTDIR/AssemblyFiles/HISAT2_Index/ --rna-strandness FR --dta -q -1 $OUTDIR/UntrimmedReads/1/${i}_1.fq -2 $OUTDIR/UntrimmedReads/2/${i}_2.fq -S $OUTDIR/SAM/${i}.sam --summary-file $OUTDIR/Stats/${i}_HISAT2_alignment_summary

echo 'Finished aligning'

echo 
echo 'Load modules...'
echo

ml SAMtools/1.16.1-GCC-11.3.0

echo
echo 'Converting SAM to BAM and sorting...'
samtools sort -@ 12 $OUTDIR/SAM/${i}.sam -o $OUTDIR/BAM/${i}.bam

echo 'Sorting and conversion complete.'

date







done