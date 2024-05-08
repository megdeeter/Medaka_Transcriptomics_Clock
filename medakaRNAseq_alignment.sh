#!/bin/bash
#SBATCH --job-name=RNAseq_alignment
#SBATCH --partition=highmem_p
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=300G
#SBATCH --time=72:00:00
#SBATCH --output=/scratch/med68205/transclock/log/log.%j
#SBATCH --mail-user=med68205@uga.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --array=1-85 


#Set working directory and define sample names
OUTDIR="/scratch/med68205/transclock"

sample=$(awk "NR==${SLURM_ARRAY_TASK_ID}" $OUTDIR/data/sample.names.85) #for each of the 85 samples

date

echo 'Project Directory = ' $OUTDIR
echo
echo 'Sample : ' $sample

#Task 2A: Run FastQC and compile all reports using MultiQC on raw reads

#load modules FastQC and MultiQC

echo
echo 'Loading relevant modules'
echo

#load FastQC/MultiQC
ml FastQC/0.11.9-Java-11
ml MultiQC/1.14-foss-2022a

echo
echo 'Loading modules complete'
echo

#Run FastQC on Raw Reads, fastqc outdirectory 
fastqc -o $OUTDIR/results/2024_04_05_2A/fastqc -t 10 $OUTDIR/data/rawFQ/${sample}/*.gz

#MultiQC to compile FastQC reports
multiqc -o $OUTDIR/results/2024_04_05_2A/multiqc $OUTDIR/results/2024_04_05_2A/fastqc/*fastqc.zip


echo
echo "****************** Creating Genome Index ******************"
echo

#!/bin/bash
#SBATCH --job-name=IndexHISAT2
#SBATCH --mem=40G
#SBATCH --cpus-per-task=12
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --time=7:00:00
#SBATCH --output= /scratch/med68205/transclock/log/log.%j

echo 
echo 'Loading modules...'
echo

ml HISAT2/3n-20201216-gompi-2022a
ml SAMtools/1.17-GCC-12.2.0


#Generate Genome Index
hisat2-build -p 12 $OUTDIR/data/genomeassembly/genomic.fnafile $OUTDIR/results/2024_04_25_3A/Index/OLgenome

echo
echo 'Genome Index Generated'
echo

date

echo
echo "****************** Begin alignment ******************"
echo

#Define OUTDIR2, where untrimmed reads are sorted by direction (F or R) and THEN by sample#. Duplicate organization in transclock directory later prior to deleting TRANS_CLOCK_PROCESSING, the old working directory for this project

OUTDIR2="/scratch/med68205/TRANS_CLOCK_PROCESSING/Alignment/HISAT2/UntrimmedReads"

for i in $sample
do 

hisat2 -x $OUTDIR/results/2024_04_25_3A/Index/OLgenome -p 12 --rna-strandness FR --dta -q -1 $OUTDIR2/1/${i}_1.fq -2 $OUTDIR2/2/${i}_2.fq -S $OUTDIR/results/2024_04_30_4A/SAM/${i}.sam --summary-file $OUTDIR/Stats/alignmentsum/${i}_HISAT2_alignment_summary

echo
echo 'Alignment complete'
echo

#Sort BAM files

echo
echo 'Converting SAM to BAM and sorting...'
echo

samtools sort -@ 12 $OUTDIR/results/2024_04_30_4A/SAM/${i}.sam -o $$OUTDIR/results/2024_04_30_4A/BAM/${i}.bam

echo
echo 'Sorting and conversion complete'
echo

done

echo
echo 'Finish pipeline'
echo

date



