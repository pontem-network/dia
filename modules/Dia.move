address {{sender}} {
module Dia {
    use 0x1::Signer;
    use 0x1::Errors;

    const ENOT_EXISTS: u64 = 101;

    /// Value can be stored in storage, contains current value and timestamp.
    struct Value<Currency: store> has key, store {
        value: u128,
        timestamp: u64,
    }

    /// Set new Value for sender, or overwrite existing data.  
    public fun setValue<Currency: store>(account: &signer, value: u128, timestamp: u64) acquires Value {
        let acc_addr = Signer::address_of(account);

        if (exists<Value<Currency>>(acc_addr)) {
            let stored = borrow_global_mut<Value<Currency>>(acc_addr);
            stored.value = value;
            stored.timestamp = timestamp;
        } else {
            move_to(account, Value<Currency> {
                value,
                timestamp
            });
        }
    }

    /// Get current values for Currency, stored on account.
    /// Returns value and timestamp.
    public fun getValue<Currency: store>(account: address): (u128, u64) acquires Value  {
        assert(exists<Value<Currency>>(account), Errors::custom(ENOT_EXISTS));

        let stored = borrow_global<Value<Currency>>(account);

        (stored.value, stored.timestamp)
    }
}
}
