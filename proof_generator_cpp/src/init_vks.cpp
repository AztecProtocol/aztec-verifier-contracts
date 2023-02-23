#include <iostream>

#include <plonk/composer/standard_composer.hpp>
#include <plonk/composer/ultra_composer.hpp>
#include <plonk/proof_system/verification_key/sol_gen.hpp>

#include "circuits/blake_circuit.hpp"
#include "circuits/add_2_circuit.hpp"

#include "utils/utils.hpp"
#include "utils/instance_sol_gen.hpp"

template <typename Composer, typename Circuit>
void generate_keys(std::string output_path, std::string srs_path, std::string flavour_prefix, std::string circuit_name){

    uint256_t public_inputs[4] = {0, 0, 0, 0};
    Composer composer = Circuit::generate(srs_path, public_inputs);

    std::shared_ptr<waffle::verification_key> vkey = composer.compute_verification_key();
    
    // Make verification key file upper case
    circuit_name.at(0) = toupper(circuit_name.at(0));
    flavour_prefix.at(0) = toupper(flavour_prefix.at(0));

    std::string vk_class_name =  circuit_name + flavour_prefix + "VerificationKey";
    std::string base_class_name = "Base" + flavour_prefix + "Verifier";
    std::string instance_class_name =  circuit_name + flavour_prefix + "Verifier";
    
    {
        auto vk_filename = output_path + "/keys/" + vk_class_name + ".sol";
        std::ofstream os(vk_filename);
        waffle::output_vk_sol(os, vkey, vk_class_name);
        info("VK contract written to: ", vk_filename);
    }

    {
        auto instance_filename = output_path + "/instance/" + instance_class_name + ".sol";
        std::ofstream os(instance_filename);
        output_instance(os, vk_class_name, base_class_name, instance_class_name);
        info("Verifier instance written to: ", instance_filename);
    }
}

/*
 * @brief Main entry point for the verification key generator
 *
 * 1. proof_flavour: standard, ultra
 * 2. circuit_flavour: blake, add2
 * 3. public_inputs: comma separated list of public inputs
 * 4. project_root_path: path to the solidity project root
 * 5. srs_path: path to the srs db
 */
int main(int argc, char **argv)
{
    std::vector<std::string> args(argv, argv + argc);
    // if (args.size() < 3)
    // {
    //     info(
    //         "usage: ", args[0], "[path to project root] [srs path]");
    //     return 1;
    // }
    const std::string project_root_path = (args.size() > 1) ? args[1] : DEFAULT_PROJECT_ROOT_PATH;
    const std::string srs_path = (args.size() > 2) ? args[2] : DEFAULT_SRS_PATH;

    const std::string standard_path = project_root_path + "/src/standard";
    const std::string ultra_path = project_root_path + "/src/ultra";
 
    // Generate Blake2 circuit
    generate_keys<waffle::StandardComposer, BlakeCircuit<waffle::StandardComposer>>(standard_path, srs_path, "standard", "blake");
    generate_keys<waffle::UltraComposer, BlakeCircuit<waffle::UltraComposer>>(ultra_path, srs_path, "ultra", "blake");

    // Generate Add2 circuit
    generate_keys<waffle::StandardComposer, Add2Circuit<waffle::StandardComposer>>(standard_path, srs_path, "standard", "add2");
    generate_keys<waffle::UltraComposer, Add2Circuit<waffle::UltraComposer>>(ultra_path, srs_path, "ultra", "add2");
}