#!/bin/bash
cd proof_generator_cpp
mkdir -p build && cd build

cmake ..
cmake --build . --parallel

# Build verification key contracts
src/init_vks
cd ../../../
