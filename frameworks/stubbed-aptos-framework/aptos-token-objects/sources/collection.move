module aptos_token_objects::collection {
    use std::string::String;
    use std::option::Option;
    use aptos_framework::object::{ConstructorRef, Object};
    use aptos_token_objects::royalty::Royalty;

    struct Collection has key {
        creator: address,
        description: String,
        name: String,
        uri: String,
        mutation_events: aptos_framework::event::EventHandle<MutationEvent>,
    }

    struct MutationEvent has drop, store {
        mutated_field_name: String,
        old_value: String,
        new_value: String,
    }

    public fun create_unlimited_collection(
        _creator: &signer,
        _description: String,
        _name: String,
        _royalty: Option<Royalty>,
        _uri: String,
    ): ConstructorRef {
        abort 0
    }

    public fun create_fixed_collection(
        _creator: &signer,
        _description: String,
        _max_supply: u64,
        _name: String,
        _royalty: Option<Royalty>,
        _uri: String,
    ): ConstructorRef {
        abort 0
    }

    public fun count(_collection: Object<Collection>): Option<u64> {
        std::option::none()
    }

    public fun uri(_collection: Object<Collection>): String {
        std::string::utf8(b"")
    }

    public fun name(_collection: Object<Collection>): String {
        std::string::utf8(b"")
    }
}