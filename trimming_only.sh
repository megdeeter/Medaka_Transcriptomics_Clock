#!/bin/bash
#SBATCH --job-name=TrimmingOnly
#SBATCH --partition=highmem_p
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=300G
#SBATCH --time=72:00:00
#SBATCH --output=/scratch/med68205/TRANS_CLOCK_PROCESSING/RawFastQC/Logs/log.%j
#SBATCH --mail-user=med68205@uga.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --array=1-85 


sample=$(awk "NR==${SLURM_ARRAY_TASK_ID}" /scratch/med68205/TRANS_CLOCK/usftp21.novogene.com/01.RawData/sample.names) #for each of the 85 samples

OUTDIR="/scratch/med68205/TRANS_CLOCK_PROCESSING" 

if [ ! -d $OUTDIR/Genome ]
then
    echo 'There is no genome folder.'
fi

echo
echo "************************          BEGIN PIPELINE          ************************"
echo

date

echo 'Project directory = ' $OUTDIR
#echo
echo 'Sample: ' $sample
#echo
#echo 'Raw FastQC'

##load modules for downloading/trimming experiment reads and alignment
#echo
#echo 'Loading relevant modules'
#echo

#load FastQC and MultiQC
ml FastQC/0.11.9-Java-11
ml MultiQC/1.14-foss-2022a

#echo 
#echo 'loading modules complete'
#echo

##fastqc Raw Reads
##fastqc -o $OUTDIR/RawFastQC/Logs -t 10 $OUTDIR/Data/${sample}/*.gz

##multiqc Raw Reads
##multiqc -o $OUTDIR/RawFastQC/MultiQC $OUTDIR/RawFastQC/Logs/*fastqc.zip

#echo 
#echo 'Load modules for trimming...'
#echo

#ml Trim_Galore/0.6.7-GCCcore-11.2.0
#ml Python/3.10.8-GCCcore-12.2.0
#ml pigz/2.7-GCCcore-11.3.0
#ml cutadapt/4.5-GCCcore-11.3.0

##trim raw reads

#echo
#echo 'Trimming raw reads and performing FastQC...'
#echo

#trim_galore --cores 4 --fastqc --fastqc_args "--outdir $OUTDIR/TrimmedQC" -stringency 3 -o $OUTDIR/TrimmedReads --paired $OUTDIR/Data/${sample}/${sample}_1.fq.gz $OUTDIR/Data/${sample}/${sample}_2.fq.gz
#fastqc -o $OUTDIR/TrimmedQC -t 10 $OUTDIR/TrimmedReads/*.gz

#echo
#echo 'trimming complete.'
#echo

#echo
#echo 'Concatenate all FastQC files using MultiQC...'
#echo

#multiqc -o $OUTDIR/TrimmedMultiQC $OUTDIR/TrimmedQC/*fastqc.zip

#date

#echo
#echo "************************          Generate genome index          ************************"
#echo

#!/bin/bash

#SBATCH --job-name=IndexSTAR
#SBATCH --mem=32GB
#SBATCH --cpus-per-task=8
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --time=7:00:00
#SBATCH --output=/scratch/med68205/TRANS_CLOCK_PROCESSING/Alignment/HISAT2/GenomeAssembly/Index/Log


#ml STAR/2.7.10b-GCC-11.3.0

#OUTDIR="/scratch/med68205/TRANS_CLOCK_PROCESSING/Alignment/HISAT2/GenomeAssembly" 
#STAR --runThreadN 8\
 #--runMode genomeGenerate\
 #--genomeDir $OUTDIR/Index\
 #--genomeFastaFiles $OUTDIR/GCF_002234675.1_ASM223467v1_genomic.fna\
 #--sjdbGTFfile $OUTDIR/genomic.gtf\
 #--genomeSAindexNbases 13\
 #--sjdbOverhang 149

#echo
#echo "************************          Begin Alignment          ************************"
#echo


#!/bin/bash

#SBATCH --job-name=AlignSTAR
#SBATCH --mail-user=med68205@uga.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --mem=40GB
#SBATCH --cpus-per-task=8
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --time=72:00:00
#SBATCH --output=/scratch/med68205/TRANS_CLOCK_PROCESSING/Alignment/HISAT2/GenomeAssembly/STAR_Results/Log

#ml STAR/2.7.10b-GCC-11.3.0

#OUTDIR="/scratch/med68205/TRANS_CLOCK_PROCESSING/Alignment/HISAT2/GenomeAssembly"
#sample=$(awk "NR==${SLURM_ARRAY_TASK_ID}" /scratch/med68205/TRANS_CLOCK_PROCESSING/TrimmedReads/sample.names)

#STAR --runThreadN 8\
 #--runMode alignReads\
 #--genomeDir $OUTDIR/Index\
 #--readFilesIn  /scratch/med68205/TRANS_CLOCK_PROCESSING/TrimmedReads/*${sample}_1_val_1.fq.gz  /scratch/med68205/TRANS_CLOCK_PROCESSING/TrimmedReads/*${sample}_2_val_2.fq.gz\
 #--outSAMtype BAM SortedByCoordinate\
 #--quantMode GeneCounts\
 #--outFileNamePrefix alignments_STAR/





