import "./ECLib.sol" as EC;

library Types {
    uint256 constant PROGRAM_WIDTH = 3;
    // TODO: this might not be correct    
    uint256 constant NUM_NU_CHALLENGE = 5;

    uint256 constant coset_generator0 = 0x5;
    uint256 constant coset_generator1 = 0x6;
    uint256 constant coset_generator2 = 0x7;
    uint256 constant coset_generator7 = 0xc;
    

    struct G1Point  {
        uint256 x;
        uint256 y;
    }

    struct G2Point  {
        uint256 x0;
        uint256 x1;
        uint256 y0;
        uint256 y1;
    }

    struct Proof {
        G1Point W1;
        G1Point W2;
        G1Point W3;
        G1Point Z;
        G1Point T1;
        G1Point T2;
        G1Point T3;
        uint256 w1;
        uint256 w2;
        uint256 w3;
        uint256 sigma1;
        uint256 sigma2;
        uint256 grand_product_at_z_omega;
        G1Point PI_Z;
        G1Point PI_Z_OMEGA;
    }

    struct ChallengeTranscript {
        uint256 alpha_base;
        uint256 alpha;
        uint256 zeta;
        uint256 beta;
        uint256 gamma;
        uint256 u;
        uint256 vega0;
        uint256 vega1;
        uint256 vega2;
        uint256 vega3;
        uint256 vega4;
        uint256 vega5;
    }

    struct VerificationKey {
        uint256 circuit_size;
        uint256 num_inputs;
        uint256 work_root_omega; // TODO: (i think its Ω) what is the work root? Is it the generator for the roots of unity?
        uint256 domain_inverse;
        G1Point Q1;
        G1Point Q2;
        G1Point Q3;
        G1Point QM;
        G1Point QC;
        G1Point SIGMA1;
        G1Point SIGMA2;
        G1Point SIGMA3;
        bool contains_recursive_proof;
        uint256 recursive_point_indices;
        G2Point g2;
    }

    /// Values that are required between arithmetic steps
    struct Cache {
        uint256 zeta_pow_n;
    }
}

/// @notice Convience library for adding ECpoints to an accumulator
library G1PointLib {
    struct Accumulator{
        Types.G1Point point;
    }

    function add(Accumulator memory self, Types.G1Point memory other) internal {
        self = EC.add(self, other);
    }
}