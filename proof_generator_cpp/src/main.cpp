#include <iostream>
#include<vector>
#include<sstream>
#include <bitset>

#include <plonk/composer/standard_composer.hpp>
#include <plonk/composer/ultra_composer.hpp>
#include <plonk/proof_system/verification_key/sol_gen.hpp>

#include "circuits/blake_circuit.hpp"
#include "circuits/add_2_circuit.hpp"
#include "utils/utils.hpp"

using namespace numeric;
using numeric::uint256_t;

template <typename Composer, typename Circuit>
void generate_proof(std::string srs_path, uint256_t inputs[])
{
    Composer composer = Circuit::generate(srs_path, inputs);
    
    std::shared_ptr<waffle::proving_key> pkey = composer.compute_proving_key();
    std::shared_ptr<waffle::verification_key> vkey = composer.compute_verification_key();

    auto prover = composer.create_prover();
    auto proof = prover.construct_proof();
    {
        auto verifier = composer.create_verifier();

        ASSERT(verifier.verify_proof(proof));

        std::string proof_bytes = bytes_to_hex_string(proof.proof_data);
        std::cout << proof_bytes;
    }
}

std::string pad_left(std::string input, size_t length) {
    return std::string(length - std::min(length, input.length()), '0') + input;
}

/**
 * @brief Main entry point for the proof generator.
 * expected inputs 
 * 1. proof_flavour: standard, ultra
 * 2. circuit_flavour: blake, add2
 * 3. public_inputs: comma separated list of public inputs
 * 4. project_root_path: path to the solidity project root
 * 5. srs_path: path to the srs db
*/
int main(int argc, char **argv)
{   
    std::vector<std::string> args(argv, argv + argc);
    
    const std::string proof_flavour = (args.size() > 1) ? args[1] : "standard";
    const std::string circuit_flavour = (args.size() > 2) ? args[2] : "blake";

    // comma separated list of inputs
    const std::string string_input = (args.size() > 3) ? args[3] : "";

    // @todo dynamically allocate this
    uint256_t inputs[] = {0,0,0,0,0};

    // equiv public_inputs = string_input.split(",")
    // @note Ran into issues with the old way of splitting strings so I used this instead
    std::vector<std::string> result;
    std::stringstream s_stream(string_input); //create string stream from the string
    while(s_stream.good()) {
      std::string substr;
      getline(s_stream, substr, ','); //get first string delimited by comma
      result.push_back(substr);
    }
   for(int i = 0; i < result.size(); i++) {    //print all splitted strings
      std::string padded = pad_left(result.at(i) , 64);
      inputs[i] = uint256_t(padded);
   }

    // @todo Make this depend on input
    const std::string project_root_path = DEFAULT_PROJECT_ROOT_PATH;
    const std::string srs_path = DEFAULT_SRS_PATH;

    if (proof_flavour == "standard") {
        if (circuit_flavour == "blake") {
            generate_proof<waffle::StandardComposer, BlakeCircuit<waffle::StandardComposer>>(srs_path, inputs);
        } else if (circuit_flavour == "add2") {
            generate_proof<waffle::StandardComposer, Add2Circuit<waffle::StandardComposer>>(srs_path, inputs);
        }
    } else if (proof_flavour == "ultra") {
        if (circuit_flavour == "blake") {
            generate_proof<waffle::UltraComposer, BlakeCircuit<waffle::UltraComposer>>(srs_path, inputs);
        } else if (circuit_flavour == "add2") {
            generate_proof<waffle::UltraComposer, Add2Circuit<waffle::UltraComposer>>(srs_path, inputs);
        }

    } else {
        std::cout << "Invalid proof flavour: " << proof_flavour << std::endl;
        return 1;
    }
}