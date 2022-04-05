#!/bin/bash

# this script is to find open ports on the hosts or domains
mkdir port-scan
cd port-scan
cp ../output/final_list.txt .
sudo naabu -iL final_list.txt -top-ports 1000 -verify -exclude-cdn -c 400 -rate 300 -silent -o nabu-result.txt

cat nabu-result.txt | httpx -silent -tech-detect -status-code -vhost -method -follow-redirects  -no-color -rate-limit 250 -cname -x all -o httpx_naabu.txt

git add nabu-result.txt httpx_naabu.txt 
git config --global user.email "github email "
git config --global user.name "github username"
git commit -a -m "port scannign is Done.."
git push -u origin main
notify -provider-config ../configs/notify.yaml -data ../configs/port-done -silent 
echo "complete the port scan.."
