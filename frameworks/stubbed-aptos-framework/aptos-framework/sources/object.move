module aptos_framework::object {
    use std::string::String;
    use std::signer;

    // --- STRUCTS ---
    // Has drop/store/copy, so they are safe to pass around
    struct Object<phantom T> has copy, drop, store {
        inner: address,
    }

    struct ConstructorRef has drop, store {
        self: address,
        can_delete: bool,
    }

    struct DeleteRef has drop, store { self: address }
    struct ExtendRef has drop, store { self: address }
    struct TransferRef has drop, store { self: address }

    // --- ADDRESS UTILS (Safe Logic) ---
    public fun object_address<T>(_obj: &Object<T>): address {
        _obj.inner
    }

    public fun address_from_constructor_ref(ref: &ConstructorRef): address {
        ref.self
    }

    // --- CONVERTERS (Safe Logic) ---
    public fun object_from_constructor_ref<T>(ref: &ConstructorRef): Object<T> {
        Object { inner: ref.self }
    }

    // --- CHECKS ---
    public fun object_exists<T>(_addr: address): bool {
        true // Stub: Always say yes
    }

    // --- FACTORY FUNCTIONS (Abort 0 required for return values) ---
    
    public fun create_object(_owner_address: address): ConstructorRef {
        abort 0 
    }

    public fun create_named_object(_creator: &signer, _seed: vector<u8>): ConstructorRef {
        abort 0
    }

    public fun create_sticky_object(_owner_address: address): ConstructorRef {
        abort 0
    }

    // --- SIGNER GENERATION (Abort 0 required for magic types) ---
    public fun generate_signer(_ref: &ConstructorRef): signer {
        abort 0
    }

    // --- REF GENERATION (Abort 0 required for return values) ---
    public fun generate_delete_ref(_ref: &ConstructorRef): DeleteRef { abort 0 }
    public fun generate_extend_ref(_ref: &ConstructorRef): ExtendRef { abort 0 }
    public fun generate_transfer_ref(_ref: &ConstructorRef): TransferRef { abort 0 }
}