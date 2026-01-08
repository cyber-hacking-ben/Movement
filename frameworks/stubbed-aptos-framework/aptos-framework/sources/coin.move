module aptos_framework::coin {
    use std::string::{Self, String};
    use std::option::{Self, Option};
    use std::signer;
    use aptos_framework::event::{Self, EventHandle};
    use aptos_framework::system_addresses; // ✅ Added
    use aptos_framework::optional_aggregator::{Self, OptionalAggregator}; // ✅ Added
    
    // Modern Move Imports
    use aptos_framework::fungible_asset::{Self, FungibleAsset, Metadata, MintRef, TransferRef, BurnRef};
    use aptos_framework::object::{Self, Object};

    // --- STRUCTS ---
    struct Coin<phantom CoinType> has store, drop {
        value: u64,
    }

    struct CoinStore<phantom CoinType> has key {
        coin: Coin<CoinType>,
        frozen: bool,
        deposit_events: EventHandle<DepositEvent>,
        withdraw_events: EventHandle<WithdrawEvent>,
    }

    struct CoinInfo<phantom CoinType> has key {
        name: String,
        symbol: String,
        decimals: u8,
        supply: Option<OptionalAggregator>, // ✅ Now uses the real type
    }

    struct MintCapability<phantom CoinType> has copy, store {}
    struct FreezeCapability<phantom CoinType> has copy, store {}
    struct BurnCapability<phantom CoinType> has copy, store {}

    struct DepositEvent has drop, store { amount: u64 }
    struct WithdrawEvent has drop, store { amount: u64 }

    // --- READ FUNCTIONS ---
    public fun balance<CoinType>(_owner: address): u64 { 0 }
    public fun is_account_registered<CoinType>(_account_addr: address): bool { true }
    public fun supply<CoinType>(): Option<u128> { option::none() }
    public fun name<CoinType>(): String { string::utf8(b"") }
    public fun symbol<CoinType>(): String { string::utf8(b"") }
    public fun decimals<CoinType>(): u8 { 0 }
    public fun value<CoinType>(coin: &Coin<CoinType>): u64 { coin.value }

    // --- WRITE FUNCTIONS ---
    public fun register<CoinType>(_account: &signer) {}

    public fun deposit<CoinType>(_account_addr: address, _coin: Coin<CoinType>) {
        // Coin drops automatically
    }

    public fun withdraw<CoinType>(_account: &signer, _amount: u64): Coin<CoinType> {
        abort 0
    }

    public fun transfer<CoinType>(_from: &signer, _to: address, _amount: u64) {}

    public fun merge<CoinType>(_dst_coin: &mut Coin<CoinType>, _source_coin: Coin<CoinType>) {}

    public fun extract<CoinType>(_coin: &mut Coin<CoinType>, _amount: u64): Coin<CoinType> {
        abort 0
    }

    public fun extract_all<CoinType>(_coin: &mut Coin<CoinType>): Coin<CoinType> {
        abort 0
    }

    public fun destroy_zero<CoinType>(_coin: Coin<CoinType>) {}

    // --- INITIALIZATION ---
    public fun initialize<CoinType>(
        _account: &signer,
        _name: String,
        _symbol: String,
        _decimals: u8,
        _monitor_supply: bool,
    ): (BurnCapability<CoinType>, FreezeCapability<CoinType>, MintCapability<CoinType>) {
        abort 0
    }

    public fun initialize_with_parallelizable_supply<CoinType>(
        _account: &signer,
        _name: String,
        _symbol: String,
        _decimals: u8,
        _monitor_supply: bool,
    ): (BurnCapability<CoinType>, FreezeCapability<CoinType>, MintCapability<CoinType>) {
        abort 0
    }

    // --- CAPABILITIES ---
    public fun mint<CoinType>(_amount: u64, _cap: &MintCapability<CoinType>): Coin<CoinType> {
        abort 0
    }

    public fun burn<CoinType>(_coin: Coin<CoinType>, _cap: &BurnCapability<CoinType>) {}

    public fun freeze_coin_store<CoinType>(_account_addr: address, _cap: &FreezeCapability<CoinType>) {}
    public fun unfreeze_coin_store<CoinType>(_account_addr: address, _cap: &FreezeCapability<CoinType>) {}
    
    public fun destroy_mint_cap<CoinType>(_cap: MintCapability<CoinType>) {}
    public fun destroy_freeze_cap<CoinType>(_cap: FreezeCapability<CoinType>) {}
    public fun destroy_burn_cap<CoinType>(_cap: BurnCapability<CoinType>) {}

    // --- INTEROP ---
    public fun coin_to_fungible_asset<CoinType>(_coin: Coin<CoinType>): FungibleAsset {
        abort 0
    }
}