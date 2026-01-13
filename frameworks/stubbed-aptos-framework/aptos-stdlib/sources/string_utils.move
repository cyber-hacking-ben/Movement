module aptos_std::string_utils {
    use std::string::String;
    
    public fun to_string<T>(_value: &T): String {
        std::string::utf8(b"")
    }

    // FIX: Added abort 0 to all these because T0, T1 etc. might not have drop
    public fun format1<T0>(_fmt: &vector<u8>, _arg0: T0): String {
        abort 0
    }

    public fun format2<T0, T1>(_fmt: &vector<u8>, _arg0: T0, _arg1: T1): String {
        abort 0
    }

    public fun format3<T0, T1, T2>(_fmt: &vector<u8>, _arg0: T0, _arg1: T1, _arg2: T2): String {
        abort 0
    }
}