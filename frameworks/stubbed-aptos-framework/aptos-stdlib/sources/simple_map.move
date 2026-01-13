module aptos_std::simple_map {
    use std::option::{Self, Option};

    struct SimpleMap<K, V> has copy, drop, store {
        data: vector<Element<K, V>>,
    }

    struct Element<K, V> has copy, drop, store {
        key: K,
        value: V,
    }

    public fun new<K: store, V: store>(): SimpleMap<K, V> {
        abort 0
    }

    public fun length<K: store, V: store>(_map: &SimpleMap<K, V>): u64 { 0 }

    public fun contains_key<K: store, V: store>(_map: &SimpleMap<K, V>, _key: &K): bool {
        false
    }

    // Standard 'borrow' (Critical for reading data)
    public fun borrow<K: store, V: store>(_map: &SimpleMap<K, V>, _key: &K): &V {
        abort 0
    }

    // Standard 'borrow_mut' (Critical for updating data)
    public fun borrow_mut<K: store, V: store>(_map: &mut SimpleMap<K, V>, _key: &K): &mut V {
        abort 0
    }

    public fun add<K: store, V: store>(_map: &mut SimpleMap<K, V>, _key: K, _value: V) {
    }

    // Used in your Launchpad contract
    public fun upsert<K: store, V: store>(_map: &mut SimpleMap<K, V>, _key: K, _value: V): (Option<K>, Option<V>) {
        abort 0
    }

    // Standard remove (Returns key and value)
    public fun remove<K: store + drop, V: store>(_map: &mut SimpleMap<K, V>, _key: &K): (K, V) {
        abort 0
    }

    public fun destroy_empty<K: store + drop, V: store + drop>(_map: SimpleMap<K, V>) {
    }
}