#!/bin/bash

FLAVOUR=${1:-"standard"}
INPUTS=${2:-"1,2,3,4"}

cd generators/proof_generator/build
src/proof_generator $FLAVOUR $INPUTS
cd ../../../