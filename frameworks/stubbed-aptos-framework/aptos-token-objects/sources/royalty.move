module aptos_token_objects::royalty {
    struct Royalty has drop, store, copy {
        numerator: u64,
        denominator: u64,
        payee_address: address,
    }

    public fun create(_numerator: u64, _denominator: u64, _payee_address: address): Royalty {
        abort 0
    }

    public fun get<T: key>(_obj: aptos_framework::object::Object<T>): Option<Royalty> {
        std::option::none()
    }
}