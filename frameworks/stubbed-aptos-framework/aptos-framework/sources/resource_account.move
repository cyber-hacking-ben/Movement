module aptos_framework::resource_account {
    use std::signer;
    // FIX: Must import account to get SignerCapability
    use aptos_framework::account; 

    // FIX: Returns (signer, SignerCapability) to match real framework
    public fun create_resource_account(
        _source: &signer,
        _seed: vector<u8>
    ): (signer, account::SignerCapability) {
        abort 0
    }
}
