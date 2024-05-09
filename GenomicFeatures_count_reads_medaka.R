library(GenomicAlignments)
library(GenomicFeatures)

# Change directory to where the BAM files are 

setwd("/scratch/med68205/transclock/results/2024_04_30_4A/BAM")

# List all BAM files 
all_samples <- c("ID1.bam", "ID110.bam", "ID120.bam", "ID135.bam", "ID19.bam", "ID28.bam", "ID36.bam", "ID44.bam", "ID56.bam", "ID7.bam", "ID76.bam", "ID88.bam",
                 "ID10.bam", "ID111.bam", "ID123.bam", "ID14.bam", "ID2.bam", "ID30.bam", "ID37.bam", "ID46.bam", "ID59.bam", "ID70.bam", "ID77.bam", "ID9.bam",
                 "ID101.bam", "ID114.bam", "ID125.bam", "ID140.bam",  "ID20.bam", "ID31.bam", "ID38.bam", "ID47.bam", "ID6.bam", "ID71.bam", "ID78.bam", "ID90.bam",
                 "ID102.bam",  "ID115.bam", "ID130.bam", "ID15.bam", "ID24.bam", "ID32.bam", "ID39.bam", "ID49.bam", "ID60.bam", "ID72.bam", "ID8.bam", "ID91.bam",
                 "ID103.bam", "ID117.bam", "ID132.bam", "ID16.bam", "ID25.bam", "ID33.bam", "ID40.bam", "ID50.bam", "ID61.bam", "ID73.bam", "ID81.bam", "ID94.bam",
                 "ID108.bam", "ID119.bam", "ID133.bam", "ID17.bam", "ID26.bam", "ID34.bam", "ID42.bam", "ID51.bam", "ID65.bam", "ID74.bam", "ID82.bam", "ID98.bam",
                 "ID11.bam", "ID12.bam", "ID134.bam",  "ID18.bam", "ID27.bam", "ID35.bam", "ID43.bam", "ID54.bam", "ID68.bam", "ID75.bam", "ID85.bam", "ID99.bam") 

summary(all_samples)

#Create a new object for BAM files in a single list

BAM_files<- BamFileList(all_samples)

#Create a storage object for GFF annotations
txdb <- makeTxDbFromGFF("/scratch/med68205/transclock/data/genomeassembly/genomic.gff", circ_seqs = character())
txdb

keytypes(txdb)

# Extract all exons grouped within genes - code from MDH and SLB
exons_by_genes <- exonsBy(txdb, by="gene")
exons_by_genes
write.csv(exons_by_genes, "exons_by_genes.csv")

transcript_lengths <- transcripts(txdb)
transcript_lengths
write.csv(transcript_lengths, "transcript_lengths.csv")

gene_counts <- summarizeOverlaps(features=exons_by_genes, reads=BAM_files, mode="Union", singleEnd=FALSE, ignore.strand=FALSE, fragments=TRUE)
gene_counts

counts_matrix <- assays(gene_counts)
counts_annotations <- rowRanges(gene_counts)

dim(counts_matrix)
dim(counts_annotations)

save.image()

write.csv(counts_matrix, '/scratch/med68205/transclock/results/2024_05_01_5/ReadCounts/trans_readcounts.csv') #Path to read counts csv
write.csv(counts_annotations, '/scratch/med68205/transclock/results/2024_05_01_5/ReadCounts/trans_readcounts_annotations.csv')
