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
cp ../../../../input_files_circom/* input_files_sha/ 

cp ../../../bytes.circom .

cd ../../../
mkdir ../../.config
mkdir ../../.config/procps

cp ../top/memory_top_script.sh circomlib/circuits/sha256/
chmod +x circomlib/circuits/sha256/memory_top_script.sh
cp ../top/process_top_script.sh circomlib/circuits/sha256/
chmod +x circomlib/circuits/sha256/process_top_script.sh
cp ../top/top_script.sh circomlib/circuits/sha256/
chmod +x circomlib/circuits/sha256/top_script.sh

cp ../top/memorytoprc ../../.config/procps/
cp ../top/processtoprc ../../.config/procps/
cp ../top/toprc ../../.config/procps/

cp run_* circomlib/circuits/sha256/
chmod +x circomlib/circuits/sha256/run_benchmark.sh
chmod +x circomlib/circuits/sha256/run_compile.py
chmod +x circomlib/circuits/sha256/run_export.py
chmod +x circomlib/circuits/sha256/run_prove.py
chmod +x circomlib/circuits/sha256/run_setup.py
chmod +x circomlib/circuits/sha256/run_witness.py