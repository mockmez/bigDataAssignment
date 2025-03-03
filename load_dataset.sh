#!/bin/bash
# load_dataset.sh
# This script checks if a dataset directory is present in HDFS, and if not, uploads it.

HDFS_DIR="/user/mango/dataset"
LOCAL_DIR="/data/dataset"

# Function to check if HDFS is available
function wait_for_hdfs {
  echo "Waiting for HDFS to be ready..."
  until hdfs dfs -ls / >/dev/null 2>&1; do
    echo "HDFS not available yet. Retrying in 5 seconds..."
    sleep 5
  done
  echo "HDFS is now available!"
}

wait_for_hdfs  # Ensure HDFS is ready before proceeding

# Check if dataset directory exists in HDFS
hadoop fs -test -d ${HDFS_DIR}
if [ $? -ne 0 ]; then
  echo "Dataset directory not found in HDFS. Creating directory and uploading files..."
  hadoop fs -mkdir -p ${HDFS_DIR}

  for file in ${LOCAL_DIR}/*; do
    if [ -f "$file" ]; then
      echo "Uploading $file to HDFS..."
      hadoop fs -put "$file" ${HDFS_DIR}/
    fi
  done

  echo "Dataset has been uploaded to HDFS."
else
  echo "Dataset directory already exists in HDFS."
fi
