**1. transactions.txt (Variable $INPUT)**
  - Function: This is the source file where new transaction data from the system or application comes in
  - What the script does to it: The script "grabs" its contents by moving it to a temporary file (temp_processed.txt). After moving it, the script uses the touch "$INPUT" command to recreate this file in an empty state. The goal is so the e-commerce system can immediately insert new transaction data without waiting for the ETL process to finish, and to prevent the file size from continuously growing.

**2. temp_processed.txt (Variable $TEMP_FILE)**
  - Function: This is the temporary (staging) file.
  - What the script does to it: This file is used as an isolated "operating room". By moving the data here before processing it with awk, we ensure that the transformation process will not be interrupted if new data suddenly arrives. This is also the key mechanism to ensure the job does not produce duplicate data when rerun.

**3. processed_transactions.log (Variable $OUTPUT)**
Function: This is the final destination file (the Load phase in ETL).
What the script does to it: This file will only contain "clean" transaction data that has passed the filter (transactions above 100,000) and has been transformed into uppercase. No system activity messages will go in here.

**4. info.log (Variable $INFO_LOG)**
  - Function: This is the Activity Log file.
  - What the script does to it: This file is responsible for recording what the script is currently doing along with a timestamp. Examples of its contents: notifications that the script started running, that the script finished successfully, or if transactions.txt is empty so the process is temporarily halted.

**5. error.log (Variable $ERROR_LOG)**
  - Function: This is the System Error Log file.
  - What the script does to it: Thanks to the 2>> symbol, this file will specifically "catch" only actual error messages from the Linux operating system (for example, if the hard drive is suddenly full, a file lacks permissions, or an awk command fails).Note: Separating the functions between info.log, error.log, and processed_transactions.log directly solves the issue where error logs and outputs were previously mixed.  
