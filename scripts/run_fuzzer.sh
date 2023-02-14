#!/bin/bash
# TODO: generate randomness from within this script, rather than in the c++ so that we can delete the generated file

FLAVOUR=$1
RAND=$RANDOM



cd generators/proof_generator/build
# TODO: change defaults to named
src/proof_generator $1 $2 $3 $4
cd ../../../