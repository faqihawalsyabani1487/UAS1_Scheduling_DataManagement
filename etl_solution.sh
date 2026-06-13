#!/bin/bash

INPUT="transactions.txt"
OUTPUT="processed_transactions.log"
ERROR_LOG="error.log"
INFO_LOG= "info.log"
TEMP_FILE="temp_processed.txt"
ARCHIVE_DIR="archive"

touch $OUTPUT
touch $ERROR_LOG
touch $INFO_LOG
mkdir -p $ARCHIVE_DIR

if [ ! -s "$INPUT" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - INFO: File $INPUT kosong atau tidak ada. Proses dihentikan sementara." >> $ERROR_LOG
    exit 0
fi

mv "$INPUT" "$TEMP_FILE"

touch "$INPUT"

{
    echo "$(date '+%Y-%m-%d %H:%M:%S') - INFO: Mulai memproses data..."
    
    awk -F',' '$2 > 100000 { print toupper($0) }' $TEMP_FILE >> $OUTPUT
    
    mv "$TEMP_FILE" "$ARCHIVE_DIR/transactions_$(date +%Y%m%d_%H%M%S).txt"
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') - INFO: Proses ETL selesai dengan sukses."
} >> $INFO_LOG 2>> $ERROR_LOG
