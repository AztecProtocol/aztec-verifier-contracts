#include <stdlib/primitives/field/field.hpp>
#include <stdlib/primitives/witness/witness.hpp>
#include <stdlib/primitives/uint/uint.hpp>
#include <stdlib/primitives/bool/bool.hpp>

using numeric::uint256_t;

template <typename Composer>
class Add2Circuit
{
public:
    typedef plonk::stdlib::field_t<Composer> field_ct;
    typedef plonk::stdlib::public_witness_t<Composer> public_witness_ct;
    typedef plonk::stdlib::witness_t<Composer> witness_ct;
    typedef plonk::stdlib::byte_array<Composer> byte_array_ct;
    typedef plonk::stdlib::bool_t<Composer> bool_ct;
    typedef plonk::stdlib::uint32<Composer> uint32_ct;

    // Two public input, one private input
    static Composer generate(std::string srs_path, uint256_t inputs[])
    {   
        // TODO: assert input lengths

        Composer composer(srs_path);

        uint32_ct a(witness_ct(&composer, inputs[0]));
        uint32_ct b(public_witness_ct(&composer, inputs[1]));
        bool_ct r = (a + b) == public_witness_ct(&composer, inputs[2]);
        r.assert_equal(true);

        return composer;
    }
};