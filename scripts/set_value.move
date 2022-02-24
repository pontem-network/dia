script {
    use Std::Signer;
    use DiaRoot::Dia;

    /// Set value.
    /// C is currency generic, e.g. BTC, KSM, PONT, etc.
    fun set_value<From, To>(account: signer, value: u128, timestamp: u64) {
        let acc_addr = Signer::address_of(&account);

        Dia::set_price_value<From, To>(&account, value, timestamp);

        let (v, t) = Dia::get_price_value<From, To>(acc_addr);

        assert!(v == value, 101);
        assert!(t == timestamp, 102);
    }
}
