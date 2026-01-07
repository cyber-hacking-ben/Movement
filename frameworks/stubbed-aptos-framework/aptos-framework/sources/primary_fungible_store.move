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
    }

    public fun primary_store(_owner: address, _metadata: Object<Metadata>): Object<FungibleStore> {
        abort 0
    }

    public fun balance(_account: address, _metadata: Object<Metadata>): u64 {
        0
    }

    public fun deposit(_account: address, _fa: FungibleAsset) {
        // No logic needed, _fa drops automatically now
    }

    public fun withdraw(_account: &signer, _metadata: Object<Metadata>, _amount: u64): FungibleAsset {
        abort 0
    }

    public fun transfer(_sender: &signer, _metadata: Object<Metadata>, _recipient: address, _amount: u64) {
    }
}