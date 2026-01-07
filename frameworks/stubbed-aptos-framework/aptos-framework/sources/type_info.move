module aptos_framework::type_info {
    use std::string::String;

    struct TypeInfo has copy, drop, store {
        account_address: address,
        module_name: vector<u8>,
        struct_name: vector<u8>,
    }

    public fun type_of<T>(): TypeInfo {
        abort 0
    }

    public fun type_name<T>(): String {
        abort 0
    }
}