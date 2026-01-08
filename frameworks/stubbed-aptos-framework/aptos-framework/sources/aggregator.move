module aptos_framework::aggregator {
    struct Aggregator has store {
        handle: address,
        key: address,
        limit: u128,
    }

    public fun add(_aggregator: &mut Aggregator, _value: u128) { abort 0 }
    public fun read(_aggregator: &Aggregator): u128 { 0 }
    public fun sub(_aggregator: &mut Aggregator, _value: u128) { abort 0 }
    public fun destroy(_aggregator: Aggregator) { abort 0 }
}