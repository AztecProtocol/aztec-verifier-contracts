
import {Vm} from "forge-std/Vm.sol";
import {strings} from "stringutils/strings.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {TestBase} from "./TestBase.sol";

contract FuzzConfig 
is TestBase 
{
    using strings for *;
    using Strings for uint256;

    enum PlonkFlavour{Standard, Turbo, Ultra}

    // Vm public constant vm = Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

    constructor(){}

    /// @notice the fuzzing flavour
    PlonkFlavour public flavour;

    /// @notice the proofs public inputs
    uint256[] public public_inputs;

    function with_flavour(PlonkFlavour _flavour) public returns (FuzzConfig) {
        flavour = _flavour;
        return this;
    }

    function with_public_inputs(uint256[] memory _pub_inputs) public returns (FuzzConfig) {
        public_inputs = _pub_inputs;
        return this;
    }

    function get_flavour() internal returns (string memory) {
        if (flavour == PlonkFlavour.Standard) {
            return "standard";
        } else if (flavour == PlonkFlavour.Turbo) {
            return "turbo";
        } else if (flavour == PlonkFlavour.Ultra) {
            return "ultra";
        } else {
            revert("Invalid flavour");
        }
    }

    function bytes32ToString(bytes32 x) internal pure returns (string memory) {
        string memory result;
        for (uint256 j = 0; j < x.length; j++) {
            result = string.concat(
                result, string(abi.encodePacked(uint8(x[j]) %26 +97)));
        }
        return result;
    }

    function get_random() internal returns (string memory) {
        string[] memory time = new string[](1);
        time[0] = "./scripts/rand_bytes.sh";
        bytes memory retData = vm.ffi(time);

        return bytes32ToString(keccak256(abi.encode(bytes32(retData))));
    }

    function out_path(string memory path_randomiser) internal returns (string memory){
        return string.concat("data/", get_flavour(), "/", path_randomiser, "Proof.dat");
    }


    function cleanup(string memory out_path) internal {
        string[] memory cleanup_cmd = new string[](2);
        cleanup_cmd[0] = "rm";
        cleanup_cmd[1] = out_path;
        vm.ffi(cleanup_cmd);
    }


    function generate_proof() public returns (bytes memory) {
        // Craft an ffi call to the prover binary

        // The path to the prover executable program
        // string memory prover_path = "./generators/proof_generator/build/src/proof_generator";
        string memory prover_path = "./scripts/run_fuzzer.sh";
        string memory _flavour = get_flavour();

        // Generate an ephemeral proof file
        string memory path_randomiser = get_random();

        // Encode public inputs as a comma seperated string for the ffi call
        // string memory public_input_params = public_inputs[0].toString();
        // for (uint256 i =1; i < public_inputs.length; i++) {
        //     public_input_params = string.concat(public_input_params, ",", public_inputs[i].toString());
        // }

        // Execute the c++ prover binary
        string[] memory ffi_cmds = new string[](3);
        ffi_cmds[0] = prover_path;
        ffi_cmds[1] = _flavour;
        ffi_cmds[2] = path_randomiser;
        // ffi_cmds[3] = public_input_params;

        // TODO: Output of the ffi command should be the proof
        vm.ffi(ffi_cmds);

        string memory outpath = out_path(path_randomiser);
        bytes memory proof = readProofData(outpath);
        
        // Remove the generated proof file
        cleanup(path_randomiser);
        
        // TOOD: There might not need to be any path related stuff if we can output the proof to std out
        return proof;
    }
}