module aptos_framework::optional_aggregator {
    use aptos_framework::aggregator::Aggregator;
    use std::option::Option;

    struct OptionalAggregator has store {
        aggregator: Option<Aggregator>,
        integer: Option<u128>,
    }

    public fun new(_limit: u128, _parallelizable: bool): OptionalAggregator {
        abort 0
    }

    public fun destroy(_optional_aggregator: OptionalAggregator) {
        abort 0
    }
}