#!/bin/bash
# Note, run this script from the root of the project

# Create required directories
echo "Creating output directories..."
mkdir -p ./data
mkdir -p ./data/standard
mkdir -p ./data/ultra

# Generate circuit verification keys
echo "Generating circuit verification keys..."
./scripts/init_vks.sh

# Build the proof generator
echo "Building proof generator..."
./scripts/build_proof_generator.sh