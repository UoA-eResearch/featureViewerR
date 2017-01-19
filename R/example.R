# Bioconductor packages
library(GenomicFeatures)
library(Biostrings)
library(BSgenome)
library(bamsignals)

# CRAN packages
library(tidyverse)

# devtools packages
library(featureViewerR)

# Annotations
anno_path <- system.file("extdata", "pombe.gff", package = "featureViewerR")
txdb <- makeTxDbFromGFF(file=anno_path, dataSource="Yu et al. (2014)")

seqlevels(txdb)
transcripts(txdb)

transcripts(txdb)[435:440]
test <- transcripts(txdb, filter=list(tx_name = "snu66"))

# Select +/- 500bp around annotations 
test_region <- ranges(test)
start(test_region) <- start(test_region) -500
end(test_region) <- end(test_region) + 500

# Sequence
# ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Chromosome_Dumps/fasta/
# data filtered chr using python script
seq_path <- system.file("extdata", "S_pombe_chr.fa", package = "featureViewerR")
seqs <- readDNAStringSet(seq_path)

test_region_seq <- as.character(Views(seqs$chromosome1, test_region))

# bam coverage (for histogram)
bf_path <- system.file("extdata", "1A_data2_SRR1032899_rpd1delta_dcr1OE_bowtie_size_21_25.truncated.bam", package = "featureViewerR")
covSigs <- bamCoverage(bf_path, test, verbose=FALSE)

data <- cbind(covSigs[1]) %>% 
  as.data.frame(.) %>% 
  mutate(x = row_number()+500, y = round(ifelse(V1 == 0, log2(V1+1), log2(V1)), digits = 2)) %>% 
  select(-V1)

# check
ggplot(data, aes(x, y)) + geom_bar(stat="identity")

### To featureViewerR

features <- list(
  list(data = list(list(x=as.data.frame(ranges(test))[,1] - as.data.frame(ranges(test))[,1] + 500 , y=as.data.frame(ranges(test))[,2] - as.data.frame(ranges(test))[,1] + 500)), 
       name = "test feature 1", 
       className="test1", 
       color = "#0F8292", 
       type = "rect"),
  list(data = apply(data,1,as.list), 
       name = "test feature 2", 
       className="test1", 
       color = "#921f0f", 
       type = "line"))

featureViewer(test_region_seq, features)

apply(data,1,as.list)
