script {
    use DiaRoot::Dia;

    /// Get value.
    /// C is currency generic, e.g. BTC, KSM, PONT, etc.
    fun get_value<From, To>(account: address) {
        let (_v, _t) = Dia::get_price_value<From, To>(account);
        // Use v and t values...
    }
}
