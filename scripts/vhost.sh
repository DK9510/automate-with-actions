#!/bin/bash

# this Script is for Vhost Discovery

cd vhost/
cp ../output/final_list.txt .
cat final_list.txt | httprobe -c 100 -p http:8080 -p https:8443 -p http:81 -p https:8080 | anew http_probe.txt
cp ../domains.txt .
cat domains.txt | httprobe -c 100 -p http:8080 -p https:8443 -p http:81 -p https:8080 | anew domains_http.txt
while read -r line;
do 
	gobuster vhost -u $line -w vhost-name.txt -r -k -o vhost-out.txt -t 150 -v
	cat vhost-out.txt | grep -v 503 |cut -d " " -f 2,3,4,5,6|anew vhosts.txt
	rm vhost-out.txt
done <"domains_http.txt"
rm domains_http.txt domains.txt

cat vhosts.txt |cut -d " " -f 1| anew vhost-domain-only.txt 
cat vhost-domain-only.txt | httpx -silent -tech-detect -status-code -vhost -method -follow-redirects  -no-color -rate-limit 150 -cname -x all -websocket -o httpx_vhost.txt

git add vhosts.txt http_probe.txt vhost-domain-only.txt httpx_vhost.txt
git config --global user.mail "github email"
git config --global user.name "github username"
git commit -a -m "vhost finding Done, DK"
git branch -M main 
git push -u origin main 
echo "vhost finding is done and push to repo"
notify -provider-config ../configs/notify.yaml -data ../configs/vhost-done -silent
