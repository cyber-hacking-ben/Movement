module aptos_framework::table {
    struct Table<K, V> has store {}

    public fun new<K, V>(): Table<K, V> { abort 0 }

    public fun add<K, V>(_table: &mut Table<K, V>, _key: K, _value: V) { abort 0 }

    public fun borrow<K, V>(_table: &Table<K, V>, _key: K): &V { abort 0 }

    // --- NEW FUNCTIONS ---
    public fun borrow_mut<K, V>(_table: &mut Table<K, V>, _key: K): &mut V { 
        abort 0 
    }

    public fun remove<K, V>(_table: &mut Table<K, V>, _key: K): V {
        abort 0
    }
    
    public fun contains<K, V>(_table: &Table<K, V>, _key: K): bool {
        true
    }
}