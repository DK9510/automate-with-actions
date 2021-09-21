#!/bin/bash

cd dns-resolve/
echo "get public resolvers..."

wget -O- https://public-dns.info/nameservers.txt > public-dns-name.txt 
cp ../domains.txt .
./massdns -r public-dns-name.txt -t A -o S -w a_records.txt ../output/final_list.txt
./massdns -r public-dns-name.txt -t CNAME -o S -w cname_records.txt ../output/final_list.txt
./massdns -r public-dns-name.txt -t AAAA -o S -w aaaa_records.txt ../output/final_list.txt
./massdns -r public-dns-name.txt -t PTR -o S -w ptr_records.txt ../output/final_list.txt


while read -r line;
do 
	../scripts/brute.py ../vhost/vhost-name.txt $line | ./massdns -r public-dns-name.txt -t A -o S -w a.txt 
	cat A.txt |anew a_brute.txt
	../scripts/brute.py ../vhost/vhost-name.txt $line | ./massdns -r public-dns-name.txt -t CNAME -o S -w cname.txt 
	cat CNAME.txt |anew cname_brute.txt
	../scripts/brute.py ../vhost/vhost-name.txt $line | ./massdns -r public-dns-name.txt -t AAAA -o S -w aaaa.txt 
	cat AAAA.txt |anew aaaa_brute.txt 
	../scripts/brute.py ../vhost/vhost-name.txt $line | ./massdns -r public-dns-name.txt -t PTR -o S -w ptr.txt 
	cat ptr.txt | anew ptr_brute.txt 
done < "domains.txt"

git add a_records.txtcname_records.txt aaaa_records.txt ptr_records.txt add a_brute.txt cname_brute.txt aaaa_brute.txt ptr_brute.txt
git config --global user.email "github-email address"
git config --global user.name "github-username"
git commit -a -m "dns resolution is Done , DK"
git branch -M main
git push -u origin main
notify -provider-config ../configs/notify.yaml -data ../configs/dns-done 