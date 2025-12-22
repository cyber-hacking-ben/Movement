module aptos_framework::transfer {
    use std::signer;

    public fun transfer(
        _from: &signer,
        _to: address,
        _amount: u64
    ) {
        // Empty is actually fine here since args drop, 
        // but 'abort 0' is consistent with stubs.
        abort 0 
    }
}
