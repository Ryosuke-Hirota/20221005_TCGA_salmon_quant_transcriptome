#!/bin/bash
#$ -cwd
#$ -V

# This script is to quant transcript level by salmon alignment base mode

# 2022/10/05 made by Ryosuke Hirota

usage() {
    echo "usage: TCGA_colon_salmon_quant_transcript.sh <DATAPROCESSLIST>"
    echo "where: <DATAPROCESSLIST> is a text file with each row for a ID and file name"
    echo "       to process with <ID> <FILE> <NOW> <ALL>"
    echo "       in which"
    echo "       <ID> is the UUID of bam file"
    echo "       <FILE> is the name of bam file"
    echo "       <NOW> is the number of processing file now"
    echo "       <ALL> is the number of all files"
}


#Minimal argument checking

if [ $# -lt 1 ]; then
    usage
    exit
fi

#Set variable and process file

DATAPROCESSLIST=$1

while read -r LINE
do
    ID=$(echo $LINE | awk '{print $1}')
    FILE=$(echo $LINE | awk '{print $2}')
    NOW=$(grep -n ${ID} ${DATAPROCESSLIST} | awk -F ':' '{print $1}')
    ALL=$(grep "" -c ${DATAPROCESSLIST})

echo "ID is $ID"
echo "FILE is $FILE"

echo "now ${NOW} out of ${ALL} files processing"

echo "start processing of ${FILE}"

#Quant expression level of transcript by salmon alignment base mode

echo "quanting expression level of transcript by salmon alignment base mode"

#Salmon reference used  from gencode.v36.transcripts.fa fsw-q02\okamura-lab\Files_related_to_M1_Projects\Hirota\refereces
#gencode.v36.transcripts.fa is downloaded from https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_36/gencode.v36.transcripts.fa.gz
#Results will be saved in the Project Drive

salmon quant -t gencode.v36.transcripts.fa  -l A -a ${FILE} -o /Volumes/okamura-lab/20221006_TCGA_colon_salmon_quant_transcriptome/${ID} --gencode

echo "finish processing of ${FILE}"

done < $1

echo "All done"
date
