module aptos_framework::system_addresses {
    public fun is_aptos_framework_address(_addr: address): bool { true }
    public fun assert_aptos_framework(_account: &signer) {}
}