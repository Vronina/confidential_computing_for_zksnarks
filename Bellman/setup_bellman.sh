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
mv Cargo_main.toml sha_circ/Cargo.toml
mv main.rs sha_circ/src/main.rs
mkdir sha_circ/src/sha_circuit
mv mod.rs sha_circ/src/sha_circuit/mod.rs
mv sha256.rs sha_circ/src/sha_circuit/sha256.rs
cd sha_circ && cargo new bellman_utils --lib
cd ..
rm sha_circ/bellman_utils/Cargo.toml
cp Cargo_bellman_utils.toml sha_circ/bellman_utils/Cargo.toml
rm sha_circ/bellman_utils/src/lib.rs
cp lib.rs sha_circ/bellman_utils/src/lib.rs


mkdir sha_circ/input_files_sha
mkdir .config
mkdir .config/procps
