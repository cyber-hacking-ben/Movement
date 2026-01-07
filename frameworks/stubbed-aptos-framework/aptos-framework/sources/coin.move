module aptos_framework::coin {
    use std::signer;
    use std::string;

    struct Coin<phantom T> has store, drop {
        value: u64
    }

    struct MintCapability<phantom T> has copy, store {}
    struct BurnCapability<phantom T> has copy, store {}
    struct FreezeCapability<phantom T> has copy, store {}

    public fun balance<T>(_addr: address): u64 { 0 }
    public fun value<T>(c: &Coin<T>): u64 { c.value }
    
    // --- NEW FUNCTIONS ---
    public fun register<T>(_account: &signer) {}
    
    public fun is_account_registered<T>(_addr: address): bool {
        true 
    }

    public fun withdraw<T>(_account: &signer, _amount: u64): Coin<T> {
        abort 0
    }

    public fun deposit<T>(_addr: address, _coin: Coin<T>) {}
    // ---------------------

    public fun mint<T>(_amount: u64, _cap: &MintCapability<T>): Coin<T> { abort 0 }
    public fun burn<T>(_coin: Coin<T>, _cap: &BurnCapability<T>) { abort 0 }
    public fun transfer<T>(_from: &signer, _to: address, _amount: u64) {}

    public fun initialize<T>(
        _account: &signer,
        _name: string::String, 
        _symbol: string::String, 
        _decimals: u8,
        _monitor_supply: bool
    ): (BurnCapability<T>, FreezeCapability<T>, MintCapability<T>) {
        abort 0
    }

    public fun destroy_burn_cap<T>(_cap: BurnCapability<T>) { abort 0 }
    public fun destroy_freeze_cap<T>(_cap: FreezeCapability<T>) { abort 0 }
    public fun destroy_mint_cap<T>(_cap: MintCapability<T>) { abort 0 }
}