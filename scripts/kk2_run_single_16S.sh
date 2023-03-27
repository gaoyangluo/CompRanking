#!/bin/bash
set -e
set -m
# default parameters
PREFIX="CompRanking"
THREADS=16
SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname ${SCRIPT})
WORK_DIR=$(dirname ${SCRIPT_PATH})
# echo ${SCRIPT_PATH}
# echo ${WORK_DIR}

while getopts "i:p:m:t:d:n:o" option; do
	case "${option}" in
		i) INPUT_DIR=${OPTARG};;
		p) PREFIX=${OPTARG};;
		m) CONDA_BIN_PATH=${OPTARG};;
		t) THREADS=${OPTARG};; 
        d) DATABASE=${OPTARG};;
		n) FILENAME=${OPTARG};;
        o) OUTPUT_DIR=${OPTARG};;
		*) exit 1;;
	esac
done

# ${DATABASE}=/lomi_home/gaoyang/db/kraken2/202203
#run kk2
source ${CONDA_BIN_PATH}/activate CompRanking_alignment_env


#time start
STARTTIME=$(date +%s)
echo "[TIMESTAMP] $(date) Running Kraken2 prediction..."	
#Running plascad
# for i in ${INPUT_DIR}/${PREFIX}/CompRanking_intermediate/preprocessing/5M_contigs/*fa
# do
echo ${INPUT_DIR}/${PREFIX}/CompRanking_intermediate/preprocessing/5M_contigs/${FILENAME}_5M_contigs.fa
kraken2 --db ${DATABASE} --threads ${THREADS} --report-zero-counts \
		--report ${INPUT_DIR}/${PREFIX}/CompRanking_intermediate/preprocessing/5M_contigs/${FILENAME}_report_kk2_mpaStyle_16S.txt \
		--use-mpa-style \
		--output ${INPUT_DIR}/${PREFIX}/CompRanking_intermediate/preprocessing/5M_contigs/${FILENAME}_output_kk2_16S.txt \
		${INPUT_DIR}/${PREFIX}/CompRanking_intermediate/preprocessing/5M_contigs/${FILENAME}_5M_contigs.fa
# done
#     mv ${INPUT_DIR}/${PREFIX}/CompRanking_intermediate/preprocessing/ori_file/*_Conj_plasmids_id_out ${INPUT_DIR}/${PREFIX}/CompRanking_intermediate/MGE/plascad/  
#     mv ${INPUT_DIR}/${PREFIX}/CompRanking_intermediate/preprocessing/ori_file/*_mob_unconj_plasmids_id_out ${INPUT_DIR}/${PREFIX}/CompRanking_intermediate/MGE/plascad/
#     mv ${INPUT_DIR}/${PREFIX}/CompRanking_intermediate/preprocessing/ori_file/*_unmob_plasmids_id_out ${INPUT_DIR}/${PREFIX}/CompRanking_intermediate/MGE/plascad/
#   mv ${INPUT_DIR}/${PREFIX}/CompRanking_intermediate/preprocessing/ori_file/*_id_* ${INPUT_DIR}/${PREFIX}/CompRanking_intermediate/MGE/plascad/
#finish Running plascad
echo "[TIMESTAMP] $(date) Running Kraken2 prediction... Done"
ENDTIME=$(date +%s)
echo "[TIMER] Running Kraken2 prediction took $(($ENDTIME - $STARTTIME)) sec."
	
