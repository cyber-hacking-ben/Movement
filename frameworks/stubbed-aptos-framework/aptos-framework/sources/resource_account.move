module aptos_framework::resource_account {
    use std::signer;
    use aptos_framework::account; 

    // Returns a Tuple (signer, SignerCapability)
    public fun create_resource_account(
        _source: &signer,
        _seed: vector<u8>
    ): (signer, account::SignerCapability) {
        abort 0
    }
}