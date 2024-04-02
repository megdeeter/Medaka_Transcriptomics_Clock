#!/bin/bash
#SBATCH --job-name=TRANS_QC
#SBATCH --partition=highmem_p
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=300G
#SBATCH --time=72:00:00
#SBATCH --output=/scratch/med68205/TRANS_CLOCK_PROCESSING/RawFastQC/Logs/log.%j
#SBATCH --mail-user=med68205@uga.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --array=1-85 

#QUESTION 1: ntasks appropriate amount? cpus per task? SEE NOTES FOLDER


sample= $(awk "NR==${SLURM_ARRAY_TASK_ID}" /scratch/med68205/TRANS_CLOCK/usftp21.novogene.com/01.RawData/sample.names) #for each of the 85 samples


#Make project directory + make directory for reference genome
#Set directory to your master directory that everything is in 
OUTDIR="/scratch/med68205/TRANS_CLOCK_PROCESSING" 

if [ ! -d $OUTDIR/Genome ]
then
    echo 'There is no genome folder.'
fi

echo
echo "************************          BEGIN PIPELINE          ************************"
echo

date

echo 'Project directory = ' $OUTDIR/RawFastQC
echo
echo 'Sample: ' $sample
echo
echo 'Raw FastQC'

##load modules for downloading/trimming experiment reads and alignment
echo
echo 'Loading relevant modules'
echo

#load FastQC
ml FastQC/0.11.9-Java-11

echo 
echo 'loading modules complete'
echo


fastqc -o $OUTDIR/RawFastQC/Logs -t 10 $OUTDIR/Data/${sample}/*.gz


