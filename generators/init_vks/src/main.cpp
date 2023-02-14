#include <iostream>

#include <plonk/composer/standard_composer.hpp>
#include <plonk/composer/ultra_composer.hpp>
#include <plonk/proof_system/verification_key/sol_gen.hpp>

#include "gen_circuit/gen_circuit.hpp"

template <typename Composer>
void generate_keys(std::string output_vk_path, std::string srs_path, std::string flavour_prefix)
{

    Composer composer = GenCircuit<Composer>::generate();

    std::shared_ptr<waffle::verification_key> vkey = composer.compute_verification_key();

    {
        std::string class_name = flavour_prefix + "VerificationKey";
        auto vk_filename = output_vk_path + "/" + class_name + ".sol";
        std::ofstream os(vk_filename);

        waffle::output_vk_sol(os, vkey, class_name);
        info("VK contract written to: ", vk_filename);
    }
}

int main(int argc, char **argv)
{
    std::vector<std::string> args(argv, argv + argc);
    // if (args.size() < 3)
    // {
    //     info(
    //         "usage: ", args[0], "[path to project root] [srs path]");
    //     return 1;
    // }
    const std::string project_root_path = (args.size() > 1) ? args[1] : "../../..";
    const std::string srs_path = (args.size() > 2) ? args[2] : "../../../barretenberg/cpp/srs_db/ignition";

    const std::string standard_vk_path = project_root_path + "/src/standard/keys";
    const std::string ultra_vk_path = project_root_path + "/src/ultra/keys";

    generate_keys<waffle::StandardComposer>(standard_vk_path, srs_path, "Standard");
    generate_keys<waffle::UltraComposer>(ultra_vk_path, srs_path, "Ultra");
}