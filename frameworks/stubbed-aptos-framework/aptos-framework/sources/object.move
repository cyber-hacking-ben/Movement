module aptos_framework::object {
    use std::string::String;
    use std::signer;

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

    public fun address_from_constructor_ref(ref: &ConstructorRef): address {
        ref.self
    }

    public fun object_from_constructor_ref<T>(ref: &ConstructorRef): Object<T> {
        Object { inner: ref.self }
    }

    public fun create_object(owner_address: address): ConstructorRef {
        abort 0
    }

    public fun create_named_object(creator: &signer, seed: vector<u8>): ConstructorRef {
        abort 0
    }
}