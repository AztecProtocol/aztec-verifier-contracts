
echo "Installing foundry..."
rm -rf broadcast cache out
. ./scripts/install_foundry.sh
forge install --no-commit
# Ensure libraries are at the correct version
git submodule update --init --recursive ./lib

echo "Installing barretenberg..."
git submodule init
git submodule update

echo "Downloading srs..."
cd barretenberg/cpp
cd ./srs_db
./download_ignition.sh 3
./download_ignition_lagrange.sh 12
cd ../../../

echo "Building c++ binaries..."
./scripts/init.sh

echo "Formatting code..."
forge fmt
forge build

echo "Targets built, you are good to go!"