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

git clone https://github.com/iden3/circom.git
cd circom
. "$HOME/.cargo/env"
cargo build --release
cargo install --path circom
cd ..

git clone https://github.com/iden3/circomlib.git
cd circomlib
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
npm install snarkjs --save-dev
npm install -g n
n stable

cd circuits/sha256
mkdir tmp
mkdir phase1
wget -O phase1/powersOfTau28_final.ptau https://storage.googleapis.com/zkevm/ptau/powersOfTau28_hez_final_21.ptau 
mkdir input_files_sha

cd ../../../
mkdir .config
mkdir .config/procps
