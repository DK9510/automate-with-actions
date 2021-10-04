#!/bin/bash

sudo add-apt-repository ppa:canonical-chromium-builds/stage 
sudo apt update 
sudo apt install chromium-browser
cd aquatone
cp ../output/final_list.txt .

cat final_list.txt | ./aquatone -ports large 
cd ../
git add aquatone/ 
git config --global user.email "email@gmail.com"
git config --global user.name "github username"
git commit -m "Screen shoting is done"
git branch -M main 
git push -u origin main
echo " Screen shoting is Done.."
notify -silent -provider-config configs/notify.yaml -data configs/screen-done
