#include <iostream>

#include <plonk/composer/standard_composer.hpp>
#include <plonk/composer/ultra_composer.hpp>
#include <plonk/proof_system/verification_key/sol_gen.hpp>

#include "gen_circuit/gen_circuit.hpp"

std::string bytes_to_hex_string(const std::vector<uint8_t> &input)
{
  static const char characters[] = "0123456789ABCDEF";

  // Zeroes out the buffer unnecessarily, can't be avoided for std::string.
  std::string ret(input.size() * 2, 0);
  
  // Hack... Against the rules but avoids copying the whole buffer.
  auto buf = const_cast<char *>(ret.data());
  
  for (const auto &oneInputByte : input)
  {
    *buf++ = characters[oneInputByte >> 4];
    *buf++ = characters[oneInputByte & 0x0F];
  }
  return ret;
}


template <typename Composer>
void generate_proof(std::string output_proof_path, std::string srs_path, uint128_t public_inputs[])
{
    Composer composer = GenCircuit<Composer>::generate(public_inputs);
    
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


/**
 * @brief Main entry point for the proof generator.
*/
int main(int argc, char **argv)
{   
    std::vector<std::string> args(argv, argv + argc);
    // if (args.size() < 3)
    // {
    //     info(
    //         "usage: ", args[0], "[flavour] [hash_input] [path to project root] [srs path]");
    //     return 1;
    // }

    const std::string proof_flavour = (args.size() > 1) ? args[1] : "standard";
    // comma separated list of public hash inputs
    const std::string hash_input = (args.size() > 2) ? args[2] : "1,2,3,4";

    std::string string_input = hash_input;
    std::vector<uint64_t> input_vector;
    uint128_t public_inputs[] = {0,0,0,0};

    // thank you chat gpt i have no idea if this is performant or not
    // equiv public_inputs = string_input.split(",")
    size_t start = 0, end;
    while ((end = string_input.find(",", start)) != std::string::npos) {
        input_vector.push_back(std::stoi(string_input.substr(start, end - start)));
        start = end+ 1;
    }

    input_vector.push_back(std::stoi(string_input.substr(start)));
    std::copy(input_vector.begin(), input_vector.end(), public_inputs);


    const std::string project_root_path = (args.size() > 3) ? args[3] : "../../..";
    const std::string srs_path = (args.size() > 4) ? args[4] : "../../../barretenberg/cpp/srs_db/ignition";

    const std::string proof_path = project_root_path + "/data/" + proof_flavour ;

    if (proof_flavour == "standard")
    {
        generate_proof<waffle::StandardComposer>(proof_path, srs_path, public_inputs);
    }
    else if (proof_flavour == "ultra")
    {
        generate_proof<waffle::UltraComposer>(proof_path, srs_path, public_inputs);
    }
    else
    {
        std::cout << "Invalid proof flavour: " << proof_flavour << std::endl;
        return 1;
    }
}