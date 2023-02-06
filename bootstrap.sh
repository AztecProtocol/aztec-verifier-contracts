#!/bin/bash
set -eu

git submodule init
git submodule update
cd barretenberg/cpp
cd ./srs_db
./download_ignition.sh 3
./download_ignition_lagrange.sh 12
cd ../../../

# Clean
rm -rf broadcast cache out serve

# Install foundry.
. ./scripts/install_foundry.sh

# Install
forge install --no-commit

# Ensure libraries are at the correct version
git submodule update --init --recursive ./lib

# Compile contracts
forge build