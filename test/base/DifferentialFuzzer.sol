
import {Vm} from "forge-std/Vm.sol";
import {strings} from "stringutils/strings.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {TestBase} from "./TestBase.sol";
import "forge-std/console.sol";

contract DifferentialFuzzer is TestBase 
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

    function with_flavour(PlonkFlavour _flavour) public returns (DifferentialFuzzer) {
        flavour = _flavour;
        return this;
    }

    function with_public_inputs(uint256[] memory _pub_inputs) public returns (DifferentialFuzzer) {
        public_inputs = _pub_inputs;
        return this;
    }

    function get_flavour() internal view returns (string memory) {
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

    // Encode public inputs as a comma seperated string for the ffi call
    function get_public_inputs() internal view returns (string memory public_input_params) {
        public_input_params = ""; 
        console.log("public_inputs.length: %s", public_inputs.length);
        if (public_inputs.length > 0) {
            public_input_params = public_inputs[0].toString();
            for (uint256 i =1; i < public_inputs.length; i++) {
                public_input_params = string.concat(public_input_params, ",", public_inputs[i].toString());
            }
        }
    }

    function generate_proof() public returns (bytes memory proof) {
        // Craft an ffi call to the prover binary
        string memory prover_path = "./scripts/run_fuzzer.sh";
        string memory _flavour = get_flavour();
        string memory public_input_params = get_public_inputs();

        // Execute the c++ prover binary
        string[] memory ffi_cmds = new string[](3);
        ffi_cmds[0] = prover_path;
        ffi_cmds[1] = _flavour;
        ffi_cmds[2] = public_input_params;

        proof = vm.ffi(ffi_cmds);
    }
}