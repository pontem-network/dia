script {
    use 0x1::Signer;
    use {{sender}}::Dia;

    /// Set value.
    /// C1 and C2 are used to shape pair, e.g. BTC/USDT, DIA/USDT.
    fun set_value<C1: store, C2: store>(account: signer, value: u128, timestamp: u64) {
        let acc_addr = Signer::address_of(&account);

        Dia::setValue<C1, C2>(&account, value, timestamp);

        let (v, t) = Dia::getValue<C1, C2>(acc_addr);

        assert(v == value, 101);
        assert(t == timestamp, 102);
    }
}
