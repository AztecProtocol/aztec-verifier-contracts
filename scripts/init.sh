#!/bin/bash
# Note, run this script from the root of the project

# Create required directories
echo "Creating output directories..."
mkdir -p ./data
mkdir -p ./data/standard
mkdir -p ./data/ultra


# Build the proof generator and init vks
echo "Building proof generator..."
./scripts/build_proof_generator.sh