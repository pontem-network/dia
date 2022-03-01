#[test_only]
module DiaRoot::DiaTests {
    use Std::Signer;
    use PontemFramework::Genesis;
    use DiaRoot::Dia;
    use DiaRoot::DiaCurrencies::{BTC, USDT, DIA};

    const ERR_VALUE_NOT_MATCH: u64 = 101;
    const ERR_TS_NOT_MATCH: u64 = 102;

    #[test(root_acc = @DiemRoot, account = @TestAccount)]
    fun test_set_value(root_acc: signer, account: signer) {
        Genesis::setup(&root_acc, 1);

        let acc_addr = Signer::address_of(&account);

        // value and timestamp.
        let value = 6120223; // Two decimals.
        let timestamp = 1635454933;

        // Set value for transaction sender.
        Dia::set_price<BTC, USDT>(&account, value, timestamp);

        // Get value and match.
        let (v, ts) = Dia::get_price<BTC, USDT>(acc_addr);

        assert!(v == value, ERR_VALUE_NOT_MATCH);
        assert!(ts == timestamp, ERR_TS_NOT_MATCH);
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
        Dia::set_price<BTC, USDT>(&account, value, timestamp);

        // Get value and match.
        let (v, ts) = Dia::get_price<BTC, USDT>(acc_addr);

        assert!(v == value, 101);
        assert!(ts == timestamp, 102);

        // New values.
        let new_value = 6119855;
        let new_timestamp = 1635455000;

        Dia::set_price<BTC, USDT>(&account, new_value, new_timestamp);

        // Get new values and match.
        let (new_v, new_t) = Dia::get_price<BTC, USDT>(acc_addr);

        assert!(new_v == new_value, ERR_VALUE_NOT_MATCH);
        assert!(new_t == new_timestamp, ERR_TS_NOT_MATCH);
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
        Dia::set_price<BTC, USDT>(&account, btc_value, btc_timestamp);

        // value and timestamp.
        let dia_value = 169; // Two decimals.
        let dia_timestamp = 1635454933;

        // Set value for transaction sender.
        Dia::set_price<DIA, USDT>(&account, dia_value, dia_timestamp);

        let (btc_v, btc_t) = Dia::get_price<BTC, USDT>(acc_addr);
        let (dia_v, dia_t) = Dia::get_price<DIA, USDT>(acc_addr);

        assert!(btc_v == btc_value, 101);
        assert!(btc_t == btc_timestamp, 102);

        assert!(dia_v == dia_value, 201);
        assert!(dia_t == dia_timestamp, 202);
    }
}
