address {{sender}} {
module Dia {
    use 0x1::Signer;
    use 0x1::Vector;
    use 0x1::Diem;
    use 0x1::Errors;
    use 0x1::Event::{Self, EventHandle};

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
    /// C1 and C2 is pair generics of currency, e.g. BTC/USDT, DIA/USDT, DIA/PONT.
    struct Value<C1: store, C2: store> has key, store {
        value: u128,
        timestamp: u64,
        oracle_updates: EventHandle<OracleUpdate>,
    }

    /// Set new Value for sender, or overwrite existing data.  
    public fun setValue<C1: store, C2: store>(account: &signer, value: u128, timestamp: u64) acquires Value {
        // Get address of transaction signer.
        let acc_addr = Signer::address_of(account);

        let currency_code = getPair<C1, C2>();

        // Check if Value already exists in storage on signer address.
        if (exists<Value<C1, C2>>(acc_addr)) {
            // If exists - just update.
            let stored = borrow_global_mut<Value<C1, C2>>(acc_addr);
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
            move_to(account, Value<C1, C2> {
                value,
                timestamp,
                oracle_updates,
            });
        }
    }

    /// Get current values for Currency, stored on account.
    /// Returns value and timestamp.
    public fun getValue<C1: store, C2: store>(account: address): (u128, u64) acquires Value  {
        assert(exists<Value<C1, C2>>(account), Errors::custom(ENOT_EXISTS));

        let stored = borrow_global<Value<C1, C2>>(account);
        (stored.value, stored.timestamp)
    }

    /// Get currency pair code, e.g. BTC/USDT.
    public fun getPair<C1: store, C2: store>(): vector<u8> {
        Diem::assert_is_currency<C1>();
        Diem::assert_is_currency<C2>();

        let c1_code = Diem::currency_code<C1>();
        let c2_code = Diem::currency_code<C2>();

        let cc = Vector::empty<u8>();
        Vector::append(&mut cc, c1_code);
        Vector::append(&mut cc, b"/");
        Vector::append(&mut cc, c2_code);

        cc
    }
}
}
