module aptos_framework::coin {
    use std::signer;
    use std::string; // FIX: Import string

    struct Coin<T> has store {
        value: u64
    }

    struct MintCapability<T> has store {}
    struct BurnCapability<T> has store {}
    struct FreezeCapability<T> has store {}

    public fun balance<T>(_addr: address): u64 { 0 }
    public fun register<T>(_account: &signer) {}

    public fun mint<T>(_amount: u64, _cap: &MintCapability<T>): Coin<T> { abort 0 }
    public fun burn<T>(_coin: Coin<T>, _cap: &BurnCapability<T>) { abort 0 }
    public fun transfer<T>(_from: &signer, _to: address, _amount: u64) {}

    // FIX: Updated arguments to string::String
    public fun initialize<T>(
        _account: &signer,
        _name: string::String, 
        _symbol: string::String, 
        _decimals: u8,
        _monitor_supply: bool
    ): (BurnCapability<T>, FreezeCapability<T>, MintCapability<T>) {
        abort 0
    }

    // FIX: Added missing destructors
    public fun destroy_burn_cap<T>(_cap: BurnCapability<T>) {}
    public fun destroy_freeze_cap<T>(_cap: FreezeCapability<T>) {}
    public fun destroy_mint_cap<T>(_cap: MintCapability<T>) {}
}
