#!/bin/bash

# this script is to install necessary tools in the vm

echo "Start Installing...."
sudo apt-get update && sudo apt-get upgrade

# install go 1.17 version
wget https://dl.google.com/go/go1.17.8.linux-amd64.tar.gz 
sudo tar -xvf go1.17.8.linux-amd64.tar.gz 
sudo mv -f go /usr/local/
export GOROOT=/usr/local/go
export GOPATH=$HOME/go 
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
go version
#install gobuster 
go install -v github.com/OJ/gobuster/v3@latest
# install  tools and depandency
go install -v github.com/OWASP/Amass/v3/...@master
# amass
sudo apt install -y libpcap-dev
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
# naabu port scanner
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
# subFinder
go install -v github.com/tomnomnom/assetfinder@latest
# asset Finder
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
# Nuclei vuln scanner
go install -v github.com/projectdiscovery/notify/cmd/notify@latest
# notfy we need configuration file 
go install -v github.com/tomnomnom/anew@latest
# anew
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
# httpx
go install -v github.com/tomnomnom/httprobe@latest
#Httprobe

#go path don't remove it
export GOROOT=/usr/local/go
export GOPATH=$HOME/go 
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
#export PATH=~/go/bin:$PATH


echo "installation of tools done.." | anew msg.txt 

notify -provider-config configs/notify.yaml -data msg.txt -v 
