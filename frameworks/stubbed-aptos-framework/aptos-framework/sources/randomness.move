module aptos_framework::randomness {
    public fun u64_range(min: u64, max: u64): u64 {
        min 
    }

    public fun u64_integer(): u64 {
        0
    }

    public fun bytes(length: u64): vector<u8> {
        std::vector::empty()
    }

    public fun permutation(n: u64): vector<u64> {
        std::vector::empty()
    }
}