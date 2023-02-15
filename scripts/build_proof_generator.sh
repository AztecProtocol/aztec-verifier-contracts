cd generators/proof_generator
mkdir -p build && cd build

cmake -DISABLE_TBB=ON ..
cmake --build . --parallel

# Build verification key contracts
src/init_vks
cd ../../../