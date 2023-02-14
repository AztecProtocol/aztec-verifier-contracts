cd generators/proof_generator
mkdir -p build && cd build
cmake ..
cmake --build . --parallel
cd ../../../