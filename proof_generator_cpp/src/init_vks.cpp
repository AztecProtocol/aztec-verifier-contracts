#include <iostream>

#include <plonk/composer/standard_composer.hpp>
#include <plonk/composer/ultra_composer.hpp>
#include <plonk/proof_system/verification_key/sol_gen.hpp>

#include "circuits/blake_circuit.hpp"
#include "circuits/add_2_circuit.hpp"

#include "utils/utils.hpp"

template <typename Composer, typename Circuit>
void generate_keys(std::string output_vk_path, std::string srs_path, std::string flavour_prefix, std::string circuit_name)
{

    uint256_t public_inputs[4] = {0, 0, 0, 0};
    Composer composer = Circuit::generate(srs_path, public_inputs);

    std::shared_ptr<waffle::verification_key> vkey = composer.compute_verification_key();

    {
        std::string class_name = flavour_prefix + circuit_name + "VerificationKey";
        auto vk_filename = output_vk_path + "/" + class_name + ".sol";
        std::ofstream os(vk_filename);

        waffle::output_vk_sol(os, vkey, class_name);
        info("VK contract written to: ", vk_filename);
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

    const std::string standard_vk_path = project_root_path + "/src/standard/keys";
    const std::string ultra_vk_path = project_root_path + "/src/ultra/keys";

    // Generate Blake2 circuit
    generate_keys<waffle::StandardComposer, BlakeCircuit<waffle::StandardComposer>>(standard_vk_path, srs_path, "standard", "blake");
    generate_keys<waffle::UltraComposer, BlakeCircuit<waffle::UltraComposer>>(ultra_vk_path, srs_path, "ultra", "blake");

    // Generate Add2 circuit
    generate_keys<waffle::StandardComposer, Add2Circuit<waffle::StandardComposer>>(standard_vk_path, srs_path, "standard", "add2");
    generate_keys<waffle::UltraComposer, Add2Circuit<waffle::UltraComposer>>(ultra_vk_path, srs_path, "ultra", "add2");
}