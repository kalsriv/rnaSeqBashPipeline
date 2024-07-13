#https://www.youtube.com/watch?v=lG11JjovJHE
#!/bin/bash

SECONDS=0

# change working directory
#cd mnt/c/Users/kalsr/Documents/seqPipeline

cd seqPipeline

# STEP 1: Run fastqc
##sudo apt install fastqc
fastqc demo.fastq -o /mnt/c/Users/kalsr/Documents/seqPipeline

# run trimmomatic to trim reads with poor quality
#sudo apt install default-jre
#sudo apt install trimmomatic
#java -jar ~/Desktop/demo/tools/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads 4 data/demo.fastq data/demo_trimmed.fastq TRAILING:10 -phred33
TrimmomaticSE  -threads 4 demo.fastq demo_trimmed.fastq TRAILING:10 -phred33
#ls -althrs

echo "Trimmomatic finished running!"

fastqc demo_trimmed.fastq -o


# STEP 2: Run HISAT2
#sudo apt install hisat2
#sudo apt install samtools
# mkdir HISAT2
# get the genome indices
# wget https://genome-idx.s3.amazonaws.com/hisat/grch38_genome.tar.gz
#tar -xvf grch38_genome.tar.gz


# run alignment
#Be mindful of the directory through which you are running it may fail otherwise
hisat2 -q --rna-strandness R -x HISAT2/grch38/genome -U demo_trimmed.fastq | samtools sort -o HISAT2/demo_trimmed.bam
echo "HISAT2 finished running!"



# STEP 3: Run featureCounts - Quantification


# get gtf
# wget http://ftp.ensembl.org/pub/release-106/gtf/homo_sapiens/Homo_sapiens.GRCh38.106.gtf.gz
#gunzip -f Homo_sapiens.GRCh38.106.gtf.gz
#sudo apt install subread
featureCounts -S 2 -a ../hg38/Homo_sapiens.GRCh38.106.gtf -o quants/demo_featurecounts.txt HISAT2/demo_trimmed.bam
echo "featureCounts finished running!"


duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."



