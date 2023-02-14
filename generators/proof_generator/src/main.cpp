#include <iostream>

#include <plonk/composer/standard_composer.hpp>
#include <plonk/composer/ultra_composer.hpp>
#include <plonk/proof_system/verification_key/sol_gen.hpp>

#include "gen_circuit/gen_circuit.hpp"


template <typename Composer>
void generate_proof(std::string output_proof_path, std::string srs_path, std::string flavour_prefix, uint64_t public_inputs[])
{
    // seed randomness for the output file name
    srand((unsigned) time(NULL));
    int random = rand();
    std::string random_string = std::to_string(random);
        
    Composer composer = GenCircuit<Composer>::generate(public_inputs);
    
    std::shared_ptr<waffle::proving_key> pkey = composer.compute_proving_key();
    std::shared_ptr<waffle::verification_key> vkey = composer.compute_verification_key();

    auto prover = composer.create_prover();
    auto proof = prover.construct_proof();
    {
        // TODO: add some randomness to this output proof name
        auto proof_filename = output_proof_path + "/" + flavour_prefix + random_string + "Proof.dat";
        std::ofstream os(proof_filename);
        write(os, proof.proof_data);
        os << std::flush;
        info("proof written to: ", proof_filename);

        auto verifier = composer.create_verifier();

        ASSERT(verifier.verify_proof(proof));
        std::cout << "verification result = " << verifier.verify_proof(proof) << std::endl;
    }
}


int main(int argc, char **argv)
{   
    std::vector<std::string> args(argv, argv + argc);
    // if (args.size() < 3)
    // {
    //     info(
    //         "usage: ", args[0], "[flavour] [hash_input] [path to project root] [srs path]");
    //     return 1;
    // }

    const std::string proof_flavour = (args.size() > 1) ? args[1] : "Standard";
    // comma separated list of public hash inputs
    std::string string_input = "1,2,3,4";
    std::vector<uint64_t> input_vector;
    uint64_t public_inputs[] = {0,0,0,0};


    // thank you chat gpt i have no idea if this is performant or not
    size_t start = 0, end;
    while ((end = string_input.find(",", start)) != std::string::npos) {
        input_vector.push_back(std::stoi(string_input.substr(start, end - start)));
        start = end+ 1;
    }

    input_vector.push_back(std::stoi(string_input.substr(start)));
    std::copy(input_vector.begin(), input_vector.end(), public_inputs);


    const std::string hash_input = (args.size() > 2) ? args[2] : "0x1234567890abcdef";
    const std::string project_root_path = (args.size() > 3) ? args[3] : "../../..";
    const std::string srs_path = (args.size() > 4) ? args[4] : "../../../barretenberg/cpp/srs_db/ignition";

    const std::string standard_vk_path = project_root_path + "/src/standard/keys";
    const std::string standard_proof_path = project_root_path + "/data/standard";
    const std::string ultra_vk_path = project_root_path + "/src/ultra/keys";
    const std::string ultra_proof_path = project_root_path + "/data/ultra";

    // Check if the srs and verification keys exist - if not then generate them, otherwise just generate the proof

    if (proof_flavour == "Standard")
    {
        // TODO: standardise the proof paths
        generate_proof<waffle::StandardComposer>(standard_proof_path, srs_path, "Standard", public_inputs);
    }
    else if (proof_flavour == "Ultra")
    {
        generate_proof<waffle::UltraComposer>(ultra_proof_path, srs_path, "Ultra", public_inputs);
    }
    else
    {
        std::cout << "Invalid proof flavour: " << proof_flavour << std::endl;
        return 1;
    }
    // generate_keys_and_proofs<waffle::StandardComposer>(standard_vk_path, standard_proof_path, srs_path, "Standard");
    // generate_keys_and_proofs<waffle::UltraComposer>(ultra_vk_path, ultra_proof_path, srs_path, "Ultra");
}