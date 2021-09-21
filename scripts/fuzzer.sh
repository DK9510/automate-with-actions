#!/bin/bash

cd fuzzing/
cp ../output/final_list.txt .

cat final_list.txt | httprobe -c 500 -p http:8080 -p https:8443 -p http:81 -p https:8080 | anew fuzz_probe.txt

while read -r line;
do 
	gobuster dir -d -r -u $line -q -w critical-file.txt -t 300 -o fuzz.txt
	echo "Domain:   $line : " >> fuzz-result.txt
	cat fuzz.txt | grep -v 400 >> fuzz-result.txt
	echo " " >> fuzz-result.txt
	echo "Done for Domain :  $line " >> fuzz-result.txt

done < "fuzz_probe.txt"

git add fuzz_probe.txt fuzz-result.txt
git config --global user.email "github email"
git config --global user.name "github username"
git commit -a -m "fuzzing for Critical Dir is Done.."
git push -u origin main
echo "pushed to github"
notify -provider-config ../configs/notify.yaml -data ../configs/fuzz-done -silent 