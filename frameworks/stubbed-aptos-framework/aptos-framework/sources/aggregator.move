module aptos_framework::aggregator {
    struct Aggregator has store {
        value: u128
    }

    public fun add(_agg: &mut Aggregator, _val: u128) {}
    public fun read(_agg: &Aggregator): u128 { 0 }
} 