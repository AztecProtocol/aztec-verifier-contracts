cd generators/init_vks
mkdir -p build && cd build
cmake ..
cmake --build . --parallel
src/init_vks
cd ../../../