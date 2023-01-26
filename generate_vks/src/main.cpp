#include <iostream>

#include <plonk/composer/standard_composer.hpp>
#include <plonk/proof_system/verification_key/sol_gen.hpp>

#include "gen_circuit/gen_circuit.hpp"

int main(int, char **)
{
    waffle::StandardComposer composer = GenCircuit<waffle::StandardComposer>::generate();

    std::shared_ptr<waffle::proving_key> pkey = composer.compute_proving_key();
    std::shared_ptr<waffle::verification_key> vkey = composer.compute_verification_key();
    std::string class_name = "StandardVerificationKey";
    auto filename = "/" + class_name + ".sol";
    std::ofstream os(filename);

    waffle::output_vk_sol(os, vkey, "StandardVerifier");
    std::cout << "hello world" << std::endl;

    std::cout << "num gates = " << composer.n << std::endl;
}