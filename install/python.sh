#!/bin/bash

if [ $# -eq 0 ]; then
    echo 'Missing Python version'
    return
fi

DOWNLOAD_VERSION=${1}
DOWNLOAD_URL="https://www.python.org/ftp/python/${DOWNLOAD_VERSION}/Python-${DOWNLOAD_VERSION}.tgz"
PYTHON_VERSION=${DOWNLOAD_VERSION%.*}
FILE_NAME=$(basename ${DOWNLOAD_URL})
EXTRACTED_FOLDER_NAME=$(basename ${FILE_NAME} .tgz)

mkdir -p /tmp
cd /tmp

if ! [ -f $FILE_NAME ]; then
    wget ${DOWNLOAD_URL} -O /tmp/${FILE_NAME}
fi

tar -xzf $FILE_NAME

cd /tmp/$EXTRACTED_FOLDER_NAME
./configure
make
sudo make altinstall

rm -f /tmp/$FILE_NAME
rm -rf /tmp/$EXTRACTED_FOLDER_NAME

echo "Python${PYTHON_VERSION} installed"
