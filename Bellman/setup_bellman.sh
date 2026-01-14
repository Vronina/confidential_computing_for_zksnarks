#!/bin/bash

set -e
set -x
DEBIAN_FRONTEND=noninteractive
HOSTNAME=$(hostname)


# Install dependencies
apt-get -y install curl time jq python3-pip git parallel moreutils


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


# create new Folder and setup
cargo new sha_circ --bin
rm sha_circ/Cargo.toml
cp Cargo_main.toml sha_circ/Cargo.toml
cp main.rs sha_circ/src/main.rs
mkdir sha_circ/src/sha_circuit
cp mod.rs sha_circ/src/sha_circuit/mod.rs
cp sha256.rs sha_circ/src/sha_circuit/sha256.rs
cd sha_circ && cargo new bellman_utils --lib
cd ..
rm sha_circ/bellman_utils/Cargo.toml
cp Cargo_bellman_utils.toml sha_circ/bellman_utils/Cargo.toml
rm sha_circ/bellman_utils/src/lib.rs
cp lib.rs sha_circ/bellman_utils/src/lib.rs
cp run_benchmark.sh sha_circ/
chmod +x sha_circ/run_benchmark.sh
cp main_setup.rs sha_circ/
cp main_prove.rs sha_circ/

mkdir sha_circ/input_files_sha
cp -r ../input_files/* sha_circ/input_files_sha/
mkdir ../../.config
mkdir ../../.config/procps

cp ../top/memory_top_script.sh sha_circ/
chmod +x sha_circ/memory_top_script.sh
cp ../top/process_top_script.sh sha_circ/
chmod +x sha_circ/process_top_script.sh
cp ../top/top_script.sh sha_circ/
chmod +x sha_circ/top_script.sh

cp ../top/memorytoprc ../../.config/procps/
cp ../top/processtoprc ../../.config/procps/
cp ../top/toprc ../../.config/procps/

