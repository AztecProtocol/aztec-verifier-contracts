# Aztec Verifier Contract Test

This repo has a minimal set of test for checking verifier contracts. It is in its infancy, but will hold verifier implementations and some test proofs.

## Standard Plonk Verifier

The Standard Plonk Verifier is split into 3 contract. There is a Base, which contains logic for verification, then there is a verification key, which we spit out from Barretenberg, and then we have an "instance" which is inheriting from the base inserting a specific key into it, e.g., StandardVerificationKey.sol

## UltraPlonk Verifier

The UltraPlonk Verifier follows the same structure as the Standard Plonk verifier, under the `src/ultra` directory

## Generating Verification Keys and Proofs

Run `bootstrap.sh` to clone git submodules, bootstrap barretenberg and download SRS.

To regenerate keys + proofs, run `generate_vks_and_proofs.sh`.

# How To Run Test?

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
forge test --match-test <NAME_OF_TEST> # e.g., testWithProofOnly
```

Example to run only `testWithProofOnly` for the Standard verifier with full logs:

```bash
forge test --match-contract StandardTest --match-test testWithProofOnly -vvvv
```
