module aptos_framework::object {
    struct Object<T> has key {}

    public fun address_of<T>(_obj: &Object<T>): address {
        @0x0
    }
} 