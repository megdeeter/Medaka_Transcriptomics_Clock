#!/bin/bash
#SBATCH --job-name=TRANS_QC
#SBATCH --partition=highmem_p
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=300G
#SBATCH --time=72:00:00
#SBATCH --output=/scratch/med68205/TRANS_CLOCK_PROCESSING/TRANS_CLOCK_QC/Logs
#SBATCH --mail-user=med68205@uga.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --array=1-50 

#QUESTION: ntasks appropriate amount? cpus per task? 


sample= $(awk "NR==${SLURM_ARRAY_TASK_ID}" /scratch/med68205/TRANS_CLOCK_PROCESSING/RawFastQC) #?: original code had /sample names as the end
#QUESTION: Are these just for the sample names? Right now I have all the raw data under the above file path with each sample as its own folder. 
#In each sample folder, there are the forward and reverse reads for each. 

#Make project directory + make directory for reference genome
OUTDIR="/scratch/med68205/TRANS_CLOCK_PROCESSING" 
#QUESTION: Is this for the alignment portion or is this for everything? (QC, trimming, alignment)?
#QUESTION: Where do you put the directory for the reference genome?

if [ ! -d $OUTDIR/Genome ]
then
    echo 'There is no genome folder.'
fi

echo
echo "************************          BEGIN PIPELINE          ************************"
echo

date

echo 'Project directory = ' $OUTDIR
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

#Create directory for raw read fastqc files
echo
echo 'Creating directory for raw read QC...'
echo

if [ ! -d $OUTDIR/RawFastQC/Logs ]
then
    mkdir -p $OUTDIR/RawFastQC/Logs
fi
echo
echo 'directory created.'
echo 
fastqc -o $OUTDIR/RawFastQC/Logs -t 10 $OUTDIR/Data/RawFastQC/${sample}/*.gz

