module aptos_framework::fungible_asset {
    use std::string;
    use std::option;
    use aptos_framework::object::{Self, Object};

    // --- STRUCTS (Added 'drop' to all for Stub Safety) ---
    struct Metadata has key, store, drop {
        name: string::String,
        symbol: string::String,
        decimals: u8,
        icon_uri: string::String,
        project_uri: string::String,
    }

    struct FungibleAsset has store, drop {
        metadata: Object<Metadata>,
        amount: u64,
    }

    struct FungibleStore has key, store, drop {
        metadata: Object<Metadata>,
        balance: u64,
        frozen: bool,
    }

    struct MintRef has store, copy, drop { metadata: Object<Metadata> }
    struct TransferRef has store, copy, drop { metadata: Object<Metadata> }
    struct BurnRef has store, copy, drop { metadata: Object<Metadata> }

    // --- READ FUNCTIONS ---
    public fun amount(_fa: &FungibleAsset): u64 { 0 }
    public fun balance(_store: Object<FungibleStore>): u64 { 0 }
    public fun supply(_metadata: Object<Metadata>): option::Option<u128> { option::none() }
    public fun metadata_from_asset(_fa: &FungibleAsset): Object<Metadata> { abort 0 }
    public fun store_metadata(_store: Object<FungibleStore>): Object<Metadata> { abort 0 }

    // --- ACTIONS ---
    public fun deposit(_store: Object<FungibleStore>, _fa: FungibleAsset) {
        // Safe to ignore _fa because we added 'drop'
    }

    public fun withdraw(
        _signer: &signer,
        _store: Object<FungibleStore>,
        _amount: u64
    ): FungibleAsset {
        abort 0
    }

    public fun transfer(
        _sender: &signer,
        _from: Object<FungibleStore>,
        _to: Object<FungibleStore>,
        _amount: u64
    ) {
    }

    public fun mint(_ref: &MintRef, _amount: u64): FungibleAsset {
        abort 0
    }

    public fun burn(_ref: &BurnRef, _fa: FungibleAsset) {
    }
}