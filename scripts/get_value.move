script {
    use {{sender}}::Dia;

    /// Get value.
    /// C is currency generic, e.g. BTC, KSM, PONT, etc.
    fun get_value<C: store>(account: address) {
        let (_v, _t) = Dia::getValue<C>(account);
        // Use v and t values...
    }
}
