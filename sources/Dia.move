module DiaRoot::Dia {
    use Std::Signer;
    use Std::Errors;
    use Std::Event::{Self, EventHandle};

    /// When no data exists at oracle address.
    const ERR_PRICE_DOES_NOT_EXIST: u64 = 101;

    /// Storage.
    /// Price can be stored in storage, contains current value and timestamp.
    /// From/To is operating currencies (like BTC/USD)
    struct Price<phantom From, phantom To> has key {
        value: u128,
        timestamp: u64,
        updates: EventHandle<PriceChangeEvent<From, To>>,
    }

    /// Price is From/To, like BTC/USD
    struct PriceChangeEvent<phantom From, phantom To> has store, drop {
        value: u128,
        timestamp: u64,
    }

    /// Get current values for Currency, stored on account.
    /// Returns value and timestamp.
    public fun get_price<From, To>(account: address): (u128, u64) acquires Price {
        assert!(exists<Price<From, To>>(account), Errors::custom(ERR_PRICE_DOES_NOT_EXIST));

        let price = borrow_global<Price<From, To>>(account);
        (price.value, price.timestamp)
    }

    public fun has_price<From, To>(account: address): bool {
        exists<Price<From, To>>(account)
    }

    #[test_only]
    /// Set new Value for sender, or overwrite existing data.
    public fun set_price<From, To>(acc: &signer, value: u128, timestamp: u64) acquires Price {
        // Get address of transaction signer.
        let acc_addr = Signer::address_of(acc);

        if (exists<Price<From, To>>(acc_addr)) {
            let price = borrow_global_mut<Price<From, To>>(acc_addr);
            price.value = value;
            price.timestamp = timestamp;

            Event::emit_event(
                &mut price.updates,
                PriceChangeEvent<From, To>{ value, timestamp });
        } else {
            // create new price record
            let updates =
                Event::new_event_handle<PriceChangeEvent<From, To>>(acc);
            Event::emit_event(
                &mut updates, PriceChangeEvent<From, To> { value, timestamp });
            move_to(acc, Price<From, To> { value, timestamp, updates });
        };
    }
}
