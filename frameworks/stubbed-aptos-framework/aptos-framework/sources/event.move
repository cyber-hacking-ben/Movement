module aptos_framework::event {
    struct EventHandle<T> has store {}

    public fun emit_event<T>(
        _handle: &mut EventHandle<T>,
        _event: T
    ) {}
} 