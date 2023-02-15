cd generators/init_vks
mkdir -p build && cd build

cmake -DISABLE_TBB=ON ..
cmake --build . --parallel
src/init_vks
cd ../../../