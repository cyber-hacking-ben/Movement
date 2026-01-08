module aptos_framework::coin {
    use std::signer;
    use std::string;

    // Phantom T + Drop makes stubs easy
    struct Coin<phantom T> has store, drop {
        value: u64
    }

    struct MintCapability<phantom T> has copy, store {}
    struct BurnCapability<phantom T> has copy, store {}
    struct FreezeCapability<phantom T> has copy, store {}

    public fun balance<T>(_addr: address): u64 { 0 }
    
    public fun register<T>(_account: &signer) {}

    public fun mint<T>(_amount: u64, _cap: &MintCapability<T>): Coin<T> { 
        abort 0 
    }

    public fun burn<T>(_coin: Coin<T>, _cap: &BurnCapability<T>) { 
        abort 0 
    }

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

    // --- NEW FUNCTIONS ADDED BELOW ---

    public fun value<T>(coin: &Coin<T>): u64 {
        coin.value
    }

    public fun deposit<T>(_addr: address, _coin: Coin<T>) {
        // Since Coin has 'drop' in our stub, we can just leave this empty.
        // The compiler sees the variable goes out of scope here and is happy.
    }
}