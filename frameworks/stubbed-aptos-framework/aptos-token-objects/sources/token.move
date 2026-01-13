module aptos_token_objects::token {
    use std::string::String;
    use std::option::Option;
    use aptos_framework::object::{Self, ConstructorRef, Object};
    use aptos_token_objects::royalty::Royalty;

    struct Token has key {
        collection: Object<aptos_token_objects::collection::Collection>,
        index: u64,
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

    public fun create(
        _creator: &signer,
        _collection_name: String,
        _description: String,
        _name: String,
        _royalty: Option<Royalty>,
        _uri: String,
    ): ConstructorRef {
        abort 0
    }

    public fun create_named_token(
        _creator: &signer,
        _collection_name: String,
        _description: String,
        _name: String,
        _royalty: Option<Royalty>,
        _uri: String,
    ): ConstructorRef {
        abort 0
    }

    public fun create_token_seed(_collection: &String, _name: &String): vector<u8> {
        std::vector::empty()
    }

    public fun uri(_token: Object<Token>): String {
        std::string::utf8(b"")
    }
}