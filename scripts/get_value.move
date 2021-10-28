script {
    use {{sender}}::Dia;

    /// Get value.
    /// C1 and C2 are used to shape pair, e.g. BTC/USDT, DIA/USDT.
    fun get_value<C1: store, C2: store>(account: address) {
        let (_v, _t) = Dia::getValue<C1, C2>(account);
        // Use v and t values...
    }
}
