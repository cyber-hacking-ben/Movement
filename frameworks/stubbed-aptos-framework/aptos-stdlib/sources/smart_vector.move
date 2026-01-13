module aptos_std::smart_vector {
    use std::vector;

    struct SmartVector<T> has store {
        inline_vec: vector<T>,
        big_vec: vector<vector<T>>, 
    }

    public fun new<T: store>(): SmartVector<T> {
        abort 0
    }

    // FIX: Added abort 0 because T might not have drop
    public fun push_back<T: store>(_v: &mut SmartVector<T>, _val: T) {
        abort 0
    }

    public fun length<T: store>(_v: &SmartVector<T>): u64 {
        0
    }

    public fun is_empty<T: store>(_v: &SmartVector<T>): bool {
        true
    }

    public fun borrow<T: store>(_v: &SmartVector<T>, _i: u64): &T {
        abort 0
    }

    public fun borrow_mut<T: store>(_v: &mut SmartVector<T>, _i: u64): &mut T {
        abort 0
    }

    public fun remove<T: store>(_v: &mut SmartVector<T>, _i: u64): T {
        abort 0
    }

    public fun index_of<T: store>(_v: &SmartVector<T>, _val: &T): (bool, u64) {
        (false, 0)
    }

    public fun contains<T: store>(_v: &SmartVector<T>, _val: &T): bool {
        false
    }

    public fun to_vector<T: store + copy>(_v: &SmartVector<T>): vector<T> {
        vector::empty()
    }

    public fun clear<T: store + drop>(_v: &mut SmartVector<T>) {
    }
}