echo
echo "************************          Generate genome index          ************************"
echo

date
#!/bin/bash

#SBATCH --job-name=IndexSTAR
#SBATCH --mem=32GB
#SBATCH --cpus-per-task=8
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --time=7:00:00
#SBATCH --output=/scratch/med68205/TRANS_CLOCK_PROCESSING/Alignment/HISAT2/GenomeAssembly/Index/Log

ml STAR/2.7.10b-GCC-11.3.0

OUTDIR="/scratch/med68205/TRANS_CLOCK_PROCESSING/Alignment/HISAT2/GenomeAssembly" 
STAR --runThreadN 8\
 --runMode genomeGenerate\
 --genomeDir $OUTDIR/Index\
 --genomeFastaFiles $OUTDIR/GCF_002234675.1_ASM223467v1_genomic.fna\
 --sjdbGTFfile $OUTDIR/genomic.gtf\
 --genomeSAindexNbases 13\
 --sjdbOverhang 149






