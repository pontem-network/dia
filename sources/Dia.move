module DiaRoot::Dia {
    use Std::Signer;
    use Std::Errors;
    use Std::Event::{Self, EventHandle};
    use PontemFramework::Pontem;

    /// Events.
    struct OracleUpdate has store, drop {
        currency_code: vector<u8>, // Currency code.
        value: u128, // Value.
        timestamp: u64, // Timestamp.
    }

    /// Errors.
    /// When no data exists at oracle address.
    const ENOT_EXISTS: u64 = 101;

    /// Storage.
    /// Value can be stored in storage, contains current value and timestamp.
    /// C is currency generic, e.g. BTC, KSM, PONT, etc.
    struct Value<phantom C: store> has key, store {
        value: u128,
        timestamp: u64,
        oracle_updates: EventHandle<OracleUpdate>,
    }

    /// Set new Value for sender, or overwrite existing data.  
    public fun set_value<C: store>(account: &signer, value: u128, timestamp: u64) acquires Value {
        // Get address of transaction signer.
        let acc_addr = Signer::address_of(account);

        let currency_code = get_currency_code<C>();

        // Check if Value already exists in storage on signer address.
        if (exists<Value<C>>(acc_addr)) {
            // If exists - just update.
            let stored = borrow_global_mut<Value<C>>(acc_addr);
            stored.value = value;
            stored.timestamp = timestamp;

            // Emit event.
            Event::emit_event(
                &mut stored.oracle_updates,
                OracleUpdate {
                    currency_code,
                    value,
                    timestamp,
                }
            );
        } else {
            // If not - create Value in storage. 

            // Create oracle event handle.
            let oracle_updates = Event::new_event_handle<OracleUpdate>(account);

            // Emit event.
            Event::emit_event(
                &mut oracle_updates,
                OracleUpdate {
                    currency_code,
                    value,
                    timestamp,
                }
            );

            // Store value.
            move_to(account, Value<C> {
                value,
                timestamp,
                oracle_updates,
            });
        }
    }

    /// Get current values for Currency, stored on account.
    /// Returns value and timestamp.
    public fun get_value<C: store>(account: address): (u128, u64) acquires Value  {
        assert(exists<Value<C>>(account), Errors::custom(ENOT_EXISTS));

        let stored = borrow_global<Value<C>>(account);
        (stored.value, stored.timestamp)
    }

    /// Get currency pair code, e.g. BTC/USDT.
    public fun get_currency_code<C: store>(): vector<u8> {
        Pontem::currency_code<C>()
    }
}
