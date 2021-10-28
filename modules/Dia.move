address {{sender}} {
module Dia {
    use 0x1::Signer;
    use 0x1::Errors;

    const ENOT_EXISTS: u64 = 101;

    /// Value can be stored in storage, contains current value and timestamp.
    /// C1 and C2 is pair generics of currency, e.g. BTC/USDT, DIA/USDT, DIA/PONT.
    struct Value<C1: store, C2: store> has key, store {
        value: u128,
        timestamp: u64,
    }

    /// Set new Value for sender, or overwrite existing data.  
    public fun setValue<C1: store, C2: store>(account: &signer, value: u128, timestamp: u64) acquires Value {
        // Get address of transaction signer.
        let acc_addr = Signer::address_of(account);

        // Check if Value already exists in storage on signer address.
        if (exists<Value<C1, C2>>(acc_addr)) {
            // If exists - just update.
            let stored = borrow_global_mut<Value<C1, C2>>(acc_addr);
            stored.value = value;
            stored.timestamp = timestamp;
        } else {
            // If not - create Value in storage. 
            move_to(account, Value<C1, C2> {
                value,
                timestamp
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
}
}
