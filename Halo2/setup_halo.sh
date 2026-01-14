#!/bin/bash

set -e
set -x
DEBIAN_FRONTEND=noninteractive
HOSTNAME=$(hostname)


# Install dependencies
apt-get -y install curl time jq python3-pip git parallel


# Install ppm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install 22


# Download installer for Rust/Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Set Rust Path in Profile
export CARGOPATH=/.cargo/bin
export PATH=$PATH:/.cargo/bin
. ~/.profile

apt-get install -y moreutils

cargo new halo --bin
rm halo/Cargo.toml
cp Cargo_halo2_pse_sha.toml halo/Cargo.toml
cp main.rs halo/src/main.rs
cp main_setup.rs halo/main_setup.rs
cp main_prove.rs halo/main_prove.rs
mkdir halo/src/sha_cir/
cp mod.rs halo/src/sha_cir//mod.rs
cp sha256.rs halo/src/sha_cir/sha256.rs
cd halo && cargo new halo_utils --lib
cd ..
rm halo/halo_utils/Cargo.toml
cp Cargo_halo_utils.toml halo/halo_utils/Cargo.toml
rm halo/halo_utils/src/lib.rs
cp lib.rs halo/halo_utils/src/lib.rs

mkdir halo/input_files_sha

cp -r ../input_files/* halo/input_files_sha/
mkdir ../../.config
mkdir ../../.config/procps

cp ../top/memory_top_script.sh halo/
chmod +x halo/memory_top_script.sh
cp ../top/process_top_script.sh halo/
chmod +x halo/process_top_script.sh
cp ../top/top_script.sh halo/
chmod +x halo/top_script.sh

cp ../top/memorytoprc ../../.config/procps/
cp ../top/processtoprc ../../.config/procps/
cp ../top/toprc ../../.config/procps/

cp run_benchmark.sh halo/
chmod +x halo/run_benchmark.sh