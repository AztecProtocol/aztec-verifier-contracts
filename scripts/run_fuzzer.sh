#!/bin/bash

PLONK_FLAVOUR=${1:-"standard"}
CIRCUIT_FLAVOUR=${2:-"blake"}
INPUTS=${3:-"1,2,3,4"}

cd proof_generator_cpp/build
src/proof_generator $PLONK_FLAVOUR $CIRCUIT_FLAVOUR $INPUTS
cd ../../../