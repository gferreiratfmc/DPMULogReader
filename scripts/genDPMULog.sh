#!/bin/bash

#Uncoment line below for debugging
# set -x 

function usage() {
	echo "usage" 
	echo "`basename $0` -o to read log without address"
	echo "`basename $0` -a to read log with address"
	exit 0
}

LOG_WITH_ADDRESS=2
while getopts "hao" arg; do
  	case $arg in
    	a)
      		LOG_WITH_ADDRESS=1
      		;;
		o)
			LOG_WITH_ADDRESS=0
      		;;
      	h)
			usage
      		;;
	esac
done

case ${LOG_WITH_ADDRESS} in
	0 ) 
		DPMU_LOG_READER=/home/gferreira/DPMULogReader/bin/read_dpmu_log_wo_address
		;;
	1 )
		DPMU_LOG_READER=/home/gferreira/DPMULogReader/bin/read_dpmu_log_w_address
		;;
	2 )
		usage
		;;
esac


DPMU_LOG_DIR=/mnt/c/DPMU_LOG
DPMU_LOG_CSV=${DPMU_LOG_DIR}/csv
DPMU_LOG_XLS=${DPMU_LOG_DIR}/xls
DPMU_LOG_PROCESSED=${DPMU_LOG_DIR}/processed

NFILES=$( ls -1 ${DPMU_LOG_DIR}/DPMU_CAN_LOG_*.hex 2> /dev/null | wc -l )
if [[ ${NFILES} -lt 1 ]]; then
	echo "No file ${DPMU_LOG_DIR}/DPMU_CAN_LOG_*.hex to process"
	exit 0
else
	echo "Number of files to process: ${NFILES}"
fi

for LOG_FILE in ${DPMU_LOG_DIR}/DPMU_CAN_LOG_*.hex
do
	#echo "Processing file ${LOG_FILE}"
	
	${DPMU_LOG_READER}  ${LOG_FILE}
	FILE_NAME=$(basename $LOG_FILE)
	cat ${LOG_FILE}.csv | tr '\t' ',' > ${DPMU_LOG_CSV}/${FILE_NAME%%.*}.csv
	ssconvert ${DPMU_LOG_CSV}/${FILE_NAME%%.*}.csv ${DPMU_LOG_XLS}/${FILE_NAME%%.*}.xls
	printf "********** OPEN EXCEL FILE:\t\twslview xls/${FILE_NAME%%.*}.xls\n\n"
	rm ${DPMU_LOG_CSV}/${FILE_NAME%%.*}.csv 	
	gzip ${LOG_FILE}
	rm -f ${LOG_FILE}.csv
	#mv *.gz ${DPMU_LOG_PROCESSED}
done
