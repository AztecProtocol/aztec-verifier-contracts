#include <iostream>

#include <plonk/composer/standard_composer.hpp>
#include <plonk/composer/ultra_composer.hpp>
#include <plonk/proof_system/verification_key/sol_gen.hpp>

#include "gen_circuit/gen_circuit.hpp"

template <typename Composer>
void generate_keys_and_proofs(std::string output_vk_path, std::string output_proof_path, std::string srs_path, std::string flavour_prefix)
{

    Composer composer = GenCircuit<Composer>::generate();

    std::shared_ptr<waffle::proving_key> pkey = composer.compute_proving_key();
    std::shared_ptr<waffle::verification_key> vkey = composer.compute_verification_key();

    {
        std::string class_name = flavour_prefix + "VerificationKey";
        auto filename = output_vk_path + "/" + class_name + ".sol";
        std::ofstream os(filename);

        if constexpr (Composer::type == waffle::ComposerType::STANDARD)
        {
            waffle::output_vk_sol(os, vkey, class_name);
        }
        else
        {
            waffle::output_ultra_vk_sol(os, vkey, class_name);
        }
        std::cout << "hello world" << std::endl;

        std::cout << "num gates = " << composer.n << std::endl;
        info("VK contract written to: ", filename);
    }

    {
        auto prover = composer.create_unrolled_prover();
        auto proof = prover.construct_proof();

        auto filename = output_proof_path + "/" + flavour_prefix + "Proof.dat";
        std::ofstream os(filename);
        write(os, proof.proof_data);
        os << std::flush;
        info("proof written to: ", filename);

        auto verifier = composer.create_unrolled_verifier();

        verifier.verify_proof(proof);
    }
    std::cout << "-1/2 = " << ((-barretenberg::fr(1)) / barretenberg::fr(2)) << std::endl;
}

int main(int argc, char **argv)
{
    std::vector<std::string> args(argv, argv + argc);
    if (args.size() < 3)
    {
        info(
            "usage: ", args[0], " <output vk path> <output proof path> [srs path]");
        return 1;
    }
    const std::string output_vk_path = args[1];
    const std::string output_proof_path = args[2];

    const std::string srs_path = (args.size() > 3) ? args[3] : "../../barretenberg/cpp/srs_db/ignition";

    // generate_keys_and_proofs<waffle::StandardComposer>(output_vk_path, output_proof_path, srs_path, "Standard");
    generate_keys_and_proofs<waffle::UltraComposer>(output_vk_path, output_proof_path, srs_path, "Ultra");
}