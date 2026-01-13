module aptos_std::string_utils {
    use std::string::String;
    
    public fun to_string<T>(_value: &T): String {
        std::string::utf8(b"")
    }

    public fun format1<T0>(_fmt: &vector<u8>, _arg0: T0): String {
        std::string::utf8(b"")
    }

    public fun format2<T0, T1>(_fmt: &vector<u8>, _arg0: T0, _arg1: T1): String {
        std::string::utf8(b"")
    }

    public fun format3<T0, T1, T2>(_fmt: &vector<u8>, _arg0: T0, _arg1: T1, _arg2: T2): String {
        std::string::utf8(b"")
    }
}