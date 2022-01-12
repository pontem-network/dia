script {
    use Std::Signer;
    use DiaRoot::Dia;

    /// Set value.
    /// C is currency generic, e.g. BTC, KSM, PONT, etc.
    fun set_value<C: store>(account: signer, value: u128, timestamp: u64) {
        let acc_addr = Signer::address_of(&account);

        Dia::set_value<C>(&account, value, timestamp);

        let (v, t) = Dia::get_value<C>(acc_addr);

        assert(v == value, 101);
        assert(t == timestamp, 102);
    }
}
