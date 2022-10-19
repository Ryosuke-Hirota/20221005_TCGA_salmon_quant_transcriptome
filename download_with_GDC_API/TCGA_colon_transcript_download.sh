#!/bin/bash
#$ -cwd
#$ -V

# This script is to download bam file by GDC API

# 2022/10/13 made by Ryosuke Hirota

usage() {
    echo "usage: TCGA_colon_transcript_download.sh <DATAPROCESSLIST>"
    echo "where: <DATAPROCESSLIST> is a text file with each row for a ID"
    echo "       to process with <ID>"
    echo "       in which"
    echo "       <ID> is the UUID of bam file"
}

# Minimal argument checking

if [ $# -lt 1 ]; then
    usage
    exit
fi

# Set token, process file and variables

token=$(cat gdc-user-token.2022-10-12T00\ 39\ 06.399Z.txt)

DATAPROCESSLIST=$1

while read -r LINE
do
    ID=$(echo $LINE | awk '{print $1}')

echo "start downloading of ${ID}"

# Download bam file
curl --remote-name --remote-header-name --header "X-Auth-Token: $token" https://api.gdc.cancer.gov/data/${ID}

echo "finish downloading of ${ID}"

done < $1

echo "Done"

