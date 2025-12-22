module aptos_framework::coin {
    use std::signer;
    use std::string;

    struct Coin<T> has store {
        value: u64
    }

    // FIX: Added 'copy' to match real Aptos (Caps are usually copyable)
    struct MintCapability<T> has copy, store {}
    struct BurnCapability<T> has copy, store {}
    struct FreezeCapability<T> has copy, store {}

    public fun balance<T>(_addr: address): u64 { 0 }
    public fun register<T>(_account: &signer) {}

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

    // FIX: Added 'abort 0' to handle the lack of 'drop' ability
    public fun destroy_burn_cap<T>(_cap: BurnCapability<T>) { abort 0 }
    public fun destroy_freeze_cap<T>(_cap: FreezeCapability<T>) { abort 0 }
    public fun destroy_mint_cap<T>(_cap: MintCapability<T>) { abort 0 }
}
