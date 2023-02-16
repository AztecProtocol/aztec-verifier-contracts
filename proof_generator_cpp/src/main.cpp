#include <iostream>
#include <bitset>

#include <plonk/composer/standard_composer.hpp>
#include <plonk/composer/ultra_composer.hpp>
#include <plonk/proof_system/verification_key/sol_gen.hpp>

#include "circuits/blake_circuit.hpp"
// #include "circuits/add_2_circuit.hpp"
#include "utils/utils.hpp"

using namespace numeric;
using numeric::uint256_t;

template <typename Composer, typename Circuit>
void generate_blake_proof(std::string srs_path, uint256_t public_inputs[])
{
    Composer composer = Circuit::generate(srs_path, public_inputs);
    
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

    // comma separated list of public hash inputs
    const std::string string_input = (args.size() > 2) ? args[2] : "1,2,3,4";

    // // TODO: dynamically allocate this
    uint256_t public_inputs[] = {0,0,0,0};

    std::vector<std::string> public_inputs_strings;

    // thank you chat gpt i have no idea if this is performant or not
    // equiv public_inputs = string_input.split(",")
    // TODO: cleanup into one loop
    size_t start = 0, end;
    size_t count = 0;
    while ((end = string_input.find(",", start)) != std::string::npos) {
        std::string input = string_input.substr(start, end - start); 
        std::string padded = pad_left(input , 64);
        uint256_t as_uint256 = uint256_t(padded);
        public_inputs[count++] = as_uint256;
        start = end+ 1;
    }
    std::string padded = pad_left(string_input.substr(start), 64);
    uint256_t last_uint256 = uint256_t(padded);
    public_inputs[count] = last_uint256;

    const std::string project_root_path = (args.size() > 3) ? args[3] : DEFAULT_PROJECT_ROOT_PATH;
    const std::string srs_path = (args.size() > 4) ? args[4] : DEFAULT_SRS_PATH;

    if (proof_flavour == "standard")
    {
        generate_blake_proof<waffle::StandardComposer, BlakeCircuit<waffle::StandardComposer>>(srs_path, public_inputs);
    }
    else if (proof_flavour == "ultra")
    {
        generate_blake_proof<waffle::UltraComposer, BlakeCircuit<waffle::UltraComposer>>(srs_path, public_inputs);
    }
    else
    {
        std::cout << "Invalid proof flavour: " << proof_flavour << std::endl;
        return 1;
    }
}