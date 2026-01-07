module aptos_framework::fungible_asset {
    use std::string;
    use std::option;
    use aptos_framework::object::{Self, Object};

    // --- Structs ---
    struct Metadata has key, store {
        name: string::String,
        symbol: string::String,
        decimals: u8,
        icon_uri: string::String,
        project_uri: string::String,
    }

    struct FungibleAsset has store {
        metadata: Object<Metadata>,
        amount: u64,
    }

    struct FungibleStore has key, store {
        metadata: Object<Metadata>,
        balance: u64,
        frozen: bool,
    }

    struct MintRef has store, copy, drop { metadata: Object<Metadata> }
    struct TransferRef has store, copy, drop { metadata: Object<Metadata> }
    struct BurnRef has store, copy, drop { metadata: Object<Metadata> }

    // --- Read Functions ---
    public fun amount(fa: &FungibleAsset): u64 { 0 }
    public fun balance(store: Object<FungibleStore>): u64 { 0 }
    public fun supply(metadata: Object<Metadata>): option::Option<u128> { option::none() }
    public fun metadata_from_asset(fa: &FungibleAsset): Object<Metadata> { abort 0 }
    public fun store_metadata(store: Object<FungibleStore>): Object<Metadata> { abort 0 }

    // --- Actions ---
    public fun deposit(store: Object<FungibleStore>, fa: FungibleAsset) {
        let FungibleAsset { metadata: _, amount: _ } = fa;
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
        abort 0
    }

    public fun mint(ref: &MintRef, amount: u64): FungibleAsset {
        abort 0
    }

    public fun burn(ref: &BurnRef, fa: FungibleAsset) {
        let FungibleAsset { metadata: _, amount: _ } = fa;
    }
}