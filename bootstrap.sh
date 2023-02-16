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

echo "Targets built, you are good to go!"