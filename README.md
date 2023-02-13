# Aztec Verifier Contract Test

This repository will contain different verifier contracts that are to be used by Noir. The repository is in its infancy, but will hold verifier implementations and some test proofs. 

The implementations strive to follow the same interface and architecture across different implementations, making is as "plug-and-play" as possible for Noir. 

The verifier will follow an overall architecture as seen below, consisting of 3 contracts/libraries. Namely, the verifier algorithm (stable across circuits), the verification key (circuit dependent) and then the "verifier instance" which is a base that reads from the verification key and uses the values in the verification algorithm. Design done like this as we can then easily generate a fresh verification key for our circuits and plug it into a verifier that uses a general verification algorithm.

![Verifier architecture](./figures/verifier.png)

The verification key is currently generated using [Barretenberg](https://github.com/AztecProtocol/barretenberg/blob/master/cpp/src/aztec/proof_system/verification_key/sol_gen.hpp), Aztecs backend for generating proofs. 

## Current implementations

### Standard Plonk Verifier

A verifier for standard plonk, the version of plonk that is used to run the [Aztec Connect](https://aztec.network/connect/) rollup.

The contracts are in the `src/standard` directory. 

### UltraPlonk Verifier

The UltraPlonk Verifier follows the same structure as the Standard Plonk verifier, under the `src/ultra` directory

## Generating Verification Keys and Proofs

Run `bootstrap.sh` to clone git submodules, bootstrap barretenberg and download SRS.

To regenerate keys + proofs, run `generate_vks_and_proofs.sh`. This generates keys and proofs for both the standard and ultra plonk setups. Proof are stored in `data/<version>`.


# Tests

Test are done with a `TestBase` contract which provides a helper for reading the file and printing proofs etc. The test require that proofs and verification keys are generated so please run `generate_vks_and_proofs.sh` before trying to run the tests. 

## How To Run Test?

To run all test, at the root of the repo, run:

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
