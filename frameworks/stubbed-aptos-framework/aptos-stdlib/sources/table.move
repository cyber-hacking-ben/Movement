module aptos_std::table {
    // Added 'phantom' to avoid "unused type parameter" errors in struct definition
    struct Table<phantom K, phantom V> has store {}

    public fun new<K, V>(): Table<K, V> {
        abort 0
    }

    public fun add<K, V>(_table: &mut Table<K, V>, _key: K, _value: V) {
        abort 0
    }

    public fun borrow<K, V>(_table: &Table<K, V>, _key: K): &V {
        abort 0
    }

    public fun borrow_mut<K, V>(_table: &mut Table<K, V>, _key: K): &mut V {
        abort 0
    }

    public fun length<K, V>(_table: &Table<K, V>): u64 {
        0
    }

    public fun empty<K, V>(_table: &Table<K, V>): bool {
        true
    }

    // --- THE FIX IS HERE ---
    // Previously, this was just "true".
    // Changed it to "abort 0" so it doesn't complain about dropping '_key'.
    public fun contains<K, V>(_table: &Table<K, V>, _key: K): bool {
        abort 0
    }

    public fun remove<K, V>(_table: &mut Table<K, V>, _key: K): V {
        abort 0
    }

    public fun destroy_empty<K, V>(_table: Table<K, V>) {
        abort 0
    }
}