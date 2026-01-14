#!/bin/bash

set -e
set -x
DEBIAN_FRONTEND=noninteractive
HOSTNAME=$(hostname)


# Install dependencies
apt-get -y install curl time jq python3-pip git parallel
apt-get install -y moreutils

# install go and run go mod tidy
wget https://go.dev/dl/go1.23.6.linux-amd64.tar.gz
rm -rf /usr/bin/go && tar -C /usr/local -xzf go1.23.6.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin 

mkdir sha_gnark
cd sha_gnark
go mod init sha_gnark
rm go.mod

cp ../go.mod .
cp ../sha_main_plonk_setup.go .
cp ../sha_main_plonk_prove.go .

mkdir input_files_sha
#cd ..
cp -r ../../input_files_gnark/* input_files_sha

cp ../run_benchmark_plonk.sh .

go mod tidy
#cd ../../
#cd .config
#mkdir procps
cd ..

mkdir ../../.config/procps

cp ../top/memory_top_script.sh sha_gnark/
chmod +x sha_gnark/memory_top_script.sh
cp ../top/process_top_script.sh sha_gnark/
chmod +x sha_gnark/process_top_script.sh
cp ../top/top_script.sh sha_gnark/
chmod +x sha_gnark/top_script.sh

cp ../top/memorytoprc ../../.config/procps/
cp ../top/processtoprc ../../.config/procps/
cp ../top/toprc ../../.config/procps/

cp run_benchmark_plonk.sh sha_gnark/
chmod +x sha_gnark/run_benchmark_plonk.sh