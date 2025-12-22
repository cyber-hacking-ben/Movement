module aptos_framework::object {
    // FIX: Added copy, drop, store. Added 'phantom' to T to relax constraints.
    struct Object<phantom T> has copy, drop, store {
        inner: address
    }

    // FIX: Update function to return the correct struct structure
    public fun address_of<T>(_obj: &Object<T>): address {
        _obj.inner
    }
}
