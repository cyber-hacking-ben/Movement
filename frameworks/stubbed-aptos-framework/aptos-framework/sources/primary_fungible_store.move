module aptos_framework::primary_fungible_store {
    use aptos_framework::object::{Self, Object, ConstructorRef};
    use aptos_framework::fungible_asset::{Self, Metadata, FungibleAsset, FungibleStore};
    use std::string::String;
    use std::option::Option;

    public fun create_primary_store_enabled_fungible_asset(
        _constructor_ref: &ConstructorRef,
        _maximum_supply: Option<u128>,
        _name: String,
        _symbol: String,
        _decimals: u8,
        _icon_uri: String,
        _project_uri: String,
    ) {
        abort 0
    }

    public fun primary_store(owner: address, metadata: Object<Metadata>): Object<FungibleStore> {
        abort 0
    }

    public fun balance(account: address, metadata: Object<Metadata>): u64 {
        0
    }

    public fun deposit(account: address, fa: FungibleAsset) {
        let FungibleAsset { metadata: _, amount: _ } = fa;
    }

    public fun withdraw(account: &signer, metadata: Object<Metadata>, amount: u64): FungibleAsset {
        abort 0
    }

    public fun transfer(sender: &signer, metadata: Object<Metadata>, recipient: address, amount: u64) {
        abort 0
    }
}