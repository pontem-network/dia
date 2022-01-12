#[test_only]
module DiaRoot::DiaTests {
    use Std::Signer;
    use PontemFramework::Genesis;
    use DiaRoot::Dia;
    use DiaRoot::DiaCurrencies::{BTC, DIA};

    /// Errors.
    const EVALUE_NOT_MATCH: u64 = 101;
    const ETS_NOT_MATCH: u64 = 102;

    fun initialize_test(root_acc: &signer) {
        Genesis::setup(root_acc, 1);
    }

    #[test(root_acc = @DiemRoot, account = @TestAccount)]
    /// Test set value.
    fun test_set_value(root_acc: signer, account: signer) {
        Genesis::setup(&root_acc, 1);

        let acc_addr = Signer::address_of(&account);

        // value and timestamp.
        let value = 6120223; // Two decimals.
        let timestamp = 1635454933;

        // Set value for transaction sender.
        Dia::set_value<BTC>(&account, value, timestamp);

        // Get value and match.
        let (v, t) = Dia::get_value<BTC>(acc_addr);

        assert(v == value, EVALUE_NOT_MATCH);
        assert(t == timestamp, ETS_NOT_MATCH);
    }


    #[test(root_acc = @DiemRoot, account = @TestAccount)]
    /// Test rewrite value.
    fun test_rewrite_value(root_acc: signer, account: signer) {
        Genesis::setup(&root_acc, 1);

        let acc_addr = Signer::address_of(&account);

        // value and timestamp.
        let value = 6120223; // Two decimals.
        let timestamp = 1635454933;

        // Set value for transaction sender.
        Dia::set_value<BTC>(&account, value, timestamp);

        // Get value and match.
        let (v, t) = Dia::get_value<BTC>(acc_addr);

        assert(v == value, 101);
        assert(t == timestamp, 102);

        // New values.
        let new_value = 6119855;
        let new_timestamp = 1635455000;

        Dia::set_value<BTC>(&account, new_value, new_timestamp);

        // Get new values and match.
        let (new_v, new_t) = Dia::get_value<BTC>(acc_addr);

        assert(new_v == new_value, EVALUE_NOT_MATCH);
        assert(new_t == new_timestamp, ETS_NOT_MATCH);
    }


    // Different currencies.
    #[test(root_acc = @DiemRoot, account = @TestAccount)]
    fun test_diff_curr(root_acc: signer, account: signer) {
        Genesis::setup(&root_acc, 1);

        let acc_addr = Signer::address_of(&account);

        // value and timestamp.
        let btc_value = 6120223; // Two decimals.
        let btc_timestamp = 1635454933;

        // Set value for transaction sender.
        Dia::set_value<BTC>(&account, btc_value, btc_timestamp);

        // value and timestamp.
        let dia_value = 169; // Two decimals.
        let dia_timestamp = 1635454933;

        // Set value for transaction sender.
        Dia::set_value<DIA>(&account, dia_value, dia_timestamp);

        let (btc_v, btc_t) = Dia::get_value<BTC>(acc_addr);
        let (dia_v, dia_t) = Dia::get_value<DIA>(acc_addr);

        assert(btc_v == btc_value, 101);
        assert(btc_t == btc_timestamp, 102);

        assert(dia_v == dia_value, 201);
        assert(dia_t == dia_timestamp, 202);
    }
}
