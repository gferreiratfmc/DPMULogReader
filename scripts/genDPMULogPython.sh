#!/bin/bash

#Convert hex file from extracted from DPMU log memory to CSV. App coded in C
DPMU_LOG_READER=/home/gferreira/DPMULogReader/read_dpmu_log
#Versiono of previous app in python
PYTHON_DPMU_LOG_READER=${DPMU_LOG_READER}.py
DPMU_LOG_DIR=/mnt/c/DPMU_LOG
DPMU_LOG_CSV=${DPMU_LOG_DIR}/csv
DPMU_LOG_XLS=${DPMU_LOG_DIR}/xls
DPMU_LOG_PROCESSED=${DPMU_LOG_DIR}/processed


for LOG_FILE in ${DPMU_LOG_DIR}/DPMU_CAN_LOG_*.hex
do
	echo "Processing file ${LOG_FILE}"
	# if [[ -s ${LOG_FILE} ]]
	# then
	# 	echo "No log files in ${DPMU_LOG_DIR}"
	# 	exit 0
	# fi
	
	#${DPMU_LOG_READER}  ${LOG_FILE}
	python3 ${PYTHON_DPMU_LOG_READER} ${LOG_FILE}
	FILE_NAME=$(basename $LOG_FILE)
	cat ${LOG_FILE}.csv | tr '\t' ',' > ${DPMU_LOG_CSV}/${FILE_NAME%%.*}.csv
	ssconvert ${DPMU_LOG_CSV}/${FILE_NAME%%.*}.csv ${DPMU_LOG_XLS}/${FILE_NAME%%.*}.xls
	echo "OPEN EXCEL FILE: wslview xls/${FILE_NAME%%.*}.xls"
	rm ${DPMU_LOG_CSV}/${FILE_NAME%%.*}.csv 	
	gzip ${LOG_FILE}
	rm -f ${LOG_FILE}.csv
	#mv *.gz ${DPMU_LOG_PROCESSED}
done
