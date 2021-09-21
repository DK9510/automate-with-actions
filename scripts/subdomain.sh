#!/bin/bash

# this script is for subdoamin enumeration
mkdir output
cd output/
echo "starting subdomain enumeration...."
cp ../domains.txt .

## assetFinder
echo " aseet finder is running......"
cat domains.txt |assetfinder --subs-only | tee asset.txt 

## subfind
echo "subfind is running ......."
 subfinder -dL domains.txt -all -nC -oJ -silent -o subfind.json 
 cat subfind.json | jq| fgrep "host" | cut -d ':' -f 2| sed 's/"//g'| sed 's/,//g' | tee subfind.txt
 rm subfind.json
#amass

echo "amass is runnnign....."
amass enum -passive -df domains.txt -o amass.txt


cat asset.txt | anew subdomains.txt
cat subfind.txt | anew subdomains.txt
cat amass.txt | anew subdomains.txt
rm -rfd subfind* amass.txt 

# subdomains from CRT.Sh
while read -r line;
do 
    echo "finding for $line"
    ../scripts/crt-sh.py $line
done < "domains.txt"

cat crt.txt | anew subdomains.txt 


# remove outof scope domains
cp ../outofscope.txt .
../scripts/scope.py 
cat list.txt | sed 's/ //g' | anew final_list.txt 
rm list.txt 
rm asset.txt domains.txt subdomains.txt outofscope.txt crt.txt 

git add final_list.txt 
git config --global user.email "github email"
git config --global user.name "github username"
git commit -m "Subdomain enumeration completed"
git branch -M main 
git push -u origin main
echo " SUbdomain Enumeraiton is Done.."
notify -silent -provider-config ../configs/notify.yaml -data ../configs/sub-done