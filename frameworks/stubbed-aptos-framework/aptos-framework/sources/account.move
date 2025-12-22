module aptos_framework::account {
    use std::signer;

    struct Account has key, store {
        authentication_key: vector<u8>,
        sequence_number: u64,
        guid_creation_num: u64,
    }

    // FIX: Ensure this exists so resource_account can use it
    struct SignerCapability has drop, store { account: address }

    public fun create_account(_auth_key: address) {}
    public fun exists_at(_addr: address): bool { true }
    public fun get_guid_next_creation_num(_addr: address): u64 { 0 }
    public fun get_sequence_number(_addr: address): u64 { 0 }
    public fun get_authentication_key(_addr: address): vector<u8> { std::vector::empty() }
}
