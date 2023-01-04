#!/bin/bash

set -e
set -m

# default parameters
PREFIX="CompRanking"
THREADS=16
CONDA_BIN_PATH=~/miniconda/bin
SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname ${SCRIPT})
WORK_DIR=$(dirname ${SCRIPT_PATH})

while getopts "p:i:m:t:o" option; do
	case "${option}" in
		p) PREFIX=${OPTARG};;
		i) INPUT_DIR=${OPTARG};;
		m) CONDA_BIN_PATH=${OPTARG};;
		t) THREADS=${OPTARG};; 
        o) OUTPUT_DIR=${OPTARG};;
		*) exit 1;;
	esac
done
source ${CONDA_BIN_PATH}/activate CompRanking_alignment_env



AMR_DIR_tmp=$(dirname ${INPUT_DIR})
SARG_DIR=$(dirname ${AMR_DIR_tmp})/AMR/ARGranking
MobileOG_DIR=$(dirname ${AMR_DIR_tmp})/MGE/MobileOG

#blastp mobileOG
if [ -e checkdone/${PREFIX}.MobileOG.done ]; then
	echo "MobileOG predition file existed..."
else
	echo "Running MobileOG prediction..."
	#time start
	STARTTIME=$(date +%s)
	echo "[TIMESTAMP] $(date) Running MobileOG prediction..."	
	#Running Virulence Factor prediction
	for i in ${INPUT_DIR}/*faa
	do
	base=${i%%.f*}
	diamond blastp --query ${i} --db ${WORK_DIR}/databases/MobileOG-db/mobileOG-db_aa.dmnd --out ${base}_mobileOG_diamond.txt --evalue 1e-10 --outfmt 6 --threads ${THREADS} --max-target-seqs 1
	done
	#finish Running VF prediction
	echo "[TIMESTAMP] $(date) Running MobileOG prediction... Done"
	ENDTIME=$(date +%s)
	echo "[TIMER] Running MobileOG prediction took $(($ENDTIME - $STARTTIME)) sec."
	touch checkdone/${PREFIX}.MobileOG.done
	mv ${INPUT_DIR}/*mobileOG_diamond.txt ${MobileOG_DIR}
fi

