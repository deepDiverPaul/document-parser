#!/bin/sh

# Check lockfile
if [ -f run.lock ]
then
    echo "----- Script is already running -----"
    exit
fi

date +%s > run.lock

# Create a backup from input files and move files for ocr to tmp/
find /home/pi/document-vault/raw -name "* *" -type f | rename 's/ /_/g'
cp /home/pi/document-vault/raw/* /home/pi/document-vault/backup
mv /home/pi/document-vault/raw/* /home/pi/document-vault/tmp

# Convert .tif to .pdf
# echo  "----- Get the .tif and convert -----"
# for i in `ls /home/pi/document-vault/tmp/*.tif | cut -d. -f1`;
#     do tiff2pdf -o $i.pdf $i.tif;
#
#     echo  " converting $i.tif"
#     rm  $i.tif;
# done

# Start ocr the documents
echo  "----- Starting OCR -----"
echo  "----- Note: 2-5 Minutes per page! Not file -----"

for i in `ls /home/pi/document-vault/tmp/*.pdf | tr '\n' '\0' | xargs -0 -n 1 basename`;
    do ocrmypdf -l deu /home/pi/document-vault/tmp/$i /home/pi/document-vault/handled/$i &&

    echo  " OCR finish from $i"
done

# Remove raw files from ocr layered files
rm /home/pi/document-vault/tmp/*
rm run.lock

echo  "----- Finish -----"
