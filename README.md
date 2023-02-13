# Aztec Verifier Contract Test

This repository contains multiple verifier contracts and testing harnesses that are used by [Noir, our Zero-Knowledge Programming Language](https://github.com/noir-lang/noir).

The implementations maintain the same interface, regardless of the verifier flavour (Standard, Turbo, Ultra), this should enable upstream implementations to be "plug-and-play".

The verifier will follow an overall architecture below, consisting of 3 contracts/libraries. Namely, the verifier algorithm (stable across circuits), the verification key (circuit dependent) and then the "verifier instance", a base that reads from the verification key and uses the key's values in the verification algorithm. The main advantage of this design is that we can generate verification key's per circuit and plug them into a general verification algorithm.

![Verifier architecture](./figures/verifier.png)

The verification key is currently generated via [Barretenberg](https://github.com/AztecProtocol/barretenberg/blob/master/cpp/src/aztec/proof_system/verification_key/sol_gen.hpp), Aztec's backend for generating proofs.

## Current implementations

### Standard Plonk Verifier

A verifier for standard plonk, the version of plonk that is used to run the [Aztec Connect](https://aztec.network/connect/) rollup.

The contracts are in the `src/standard` directory.

### UltraPlonk Verifier

The UltraPlonk Verifier follows the same structure as the Standard Plonk verifier, under the `src/ultra` directory.

## Generating Verification Keys and Proofs

Run `bootstrap.sh` to clone git submodules, bootstrap barretenberg and download SRS.

To regenerate keys + proofs, run `generate_vks_and_proofs.sh`. This generates keys and proofs for both the standard and ultra plonk setups. Proof are stored in `data/<version>`.

# Tests

Test are performed with a `TestBase` harness, it provides helpers for reading files and printing proofs. The tests also require proofs and verification keys. To generate please run `generate_vks_and_proofs.sh` running the tests.

## How To Run the Tests?

To run all tests, run the following scripts at the root of the repo:

```bash
forge test # add -(v, vv, vvv, vvvv) for verbosity of logs, no logs emitted as default
```

To run test for a specific Contract test,

```bash
forge test --match-contract <NAME_OF_CONTRACT> # e.g., StandardTest
```

To run a specific test

```bash
forge test --match-test <NAME_OF_TEST> # e.g., testValidProof
```

Example to run only `testValidProof` for the Standard verifier with logs:

```bash
forge test --match-contract StandardTest --match-test testValidProof -vvvv
```
