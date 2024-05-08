library(GenomicAlignments)
library(GenomicFeatures)

# Change directory to where the BAM files are 

setwd("/scratch/crs12448/MEVE/Genome")

#all_samples <- c("S231.bam", "S242.bam", "S246.bam", "S247.bam", "S252.bam", "S256.bam", "S256_2.bam", "S263.bam", "S266.bam",
 #               "S266_2.bam", "S280.bam", "S295.bam", "S302.bam", "S303.bam", "S314.bam", "S316.bam", "S317.bam", "S319.bam", "S328.bam", "S336.bam",
  #              "S337.bam",  "S338.bam", "S344.bam", "S345.bam", "S348.bam", "S350.bam", "S353.bam", "S357.bam", "S359.bam", "S367.bam", "S376.bam", "S380.bam", "S384.bam",
   #             "S388.bam", "S391.bam", "S392.bam", "S393.bam", "S406.bam", "S407.bam", "S408.bam", "S416.bam", "S420.bam", "S421.bam", "S422.bam", "S425.bam", 
    #            "S426.bam", "S427.bam", "S432.bam", "S433.bam", "S435.bam")
#summary(all_samples)

# Create a new object for BAM files in a single list
#BAM_files<- BamFileList(all_samples)
#
# # Create a storage object for GTF annotations
txdb <- makeTxDbFromGFF("/scratch/crs12448/MEVE/Genome/Amiss.annot.2022.gff", circ_seqs = character())
txdb
#keytypes(txdb)

#
# # Extract all exons grouped within genes - code from MDH and SLB
exons_by_genes <- exonsBy(txdb, by="gene")
exons_by_genes
write.csv(exons_by_genes, "exons_by_genes.csv")

transcript_lengths <- transcripts(txdb)
transcript_lengths
#
write.csv(transcript_lengths, "transcript_lengths.csv")
#gene_counts <- summarizeOverlaps(features=exons_by_genes, reads=BAM_files, mode="Union", singleEnd=FALSE, ignore.strand=FALSE, fragments=TRUE)
#gene_counts

#counts_matrix <- assays(gene_counts)
#counts_annotations <- rowRanges(gene_counts)

#dim(counts_matrix)
#dim(counts_annotations)

#save.image()

#write.csv(counts_matrix, '/scratch/crs12448/MEVE/ReadCounts/MEVE_read_counts.csv')
#write.csv(counts_annotations, '/scratch/crs12448/MEVE/ReadCounts/MEVE_read_counts_annotation.csv')
