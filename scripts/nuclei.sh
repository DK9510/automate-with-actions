#!/bin/bash

# this script is for using nuclei scan

mkdir nuclei-scan
cd nuclei-scan
cp ../vhost/http_probe.txt .

nuclei -l http_probe.txt -config ../configs/nuclei.yaml -silent 

git add nuclei-result.txt 
git config --global user.email "github email"
git config --global user.name "github username"
git commit -a -m "nuclei scan Done : DK"
git push -u origin main
notify -provider-config ../configs/notify.yaml -data ../configs/nuclei-done -silent
echo "Nuclei scan is Done ; DK "

