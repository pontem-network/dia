address {{sender}} {
    module DiaTest {
        use 0x1::Signer;
        use {{sender}}::Dia;
        use {{sender}}::DiaCurrencies::{BTC, USDT, DIA};

        const EVALUE_NOT_MATCH: u64 = 101;
        const ETS_NOT_MATCH: u64 = 102;

        #[test(
            account = @5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY,
        )]
        /// Test set value.
        fun test_set_value(account: signer) {
            let acc_addr = Signer::address_of(&account);

            // value and timestamp.
            let value = 6120223; // Two decimals.
            let timestamp = 1635454933;

            // Set value for transaction sender.
            Dia::setValue<BTC, USDT>(&account, value, timestamp);

            // Get value and match.
            let (v, t) = Dia::getValue<BTC, USDT>(acc_addr);

            assert(v == value, EVALUE_NOT_MATCH);
            assert(t == timestamp, ETS_NOT_MATCH);
        }


        #[test(
            account = @5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY,
        )]
        /// Test rewrite value.
        fun test_rewrite_value(account: signer) {
            let acc_addr = Signer::address_of(&account);

            // value and timestamp.
            let value = 6120223; // Two decimals.
            let timestamp = 1635454933;

            // Set value for transaction sender.
            Dia::setValue<BTC, USDT>(&account, value, timestamp);

            // Get value and match.
            let (v, t) = Dia::getValue<BTC, USDT>(acc_addr);

            assert(v == value, 101);
            assert(t == timestamp, 102);

            // New values.
            let new_value = 6119855;
            let new_timestamp = 1635455000;

            Dia::setValue<BTC, USDT>(&account, new_value, new_timestamp);

            // Get new values and match.
            let (new_v, new_t) = Dia::getValue<BTC, USDT>(acc_addr);

            assert(new_v == new_value, EVALUE_NOT_MATCH);
            assert(new_t == new_timestamp, ETS_NOT_MATCH);
        }


        // Different currencies.
        #[test(
            account = @5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY,
        )]
        fun test_diff_curr(account: signer) {
            let acc_addr = Signer::address_of(&account);

            // value and timestamp.
            let btc_usdt_value = 6120223; // Two decimals.
            let btc_usdt_timestamp = 1635454933;

            // Set value for transaction sender.
            Dia::setValue<BTC, USDT>(&account, btc_usdt_value, btc_usdt_timestamp);

            // value and timestamp.
            let dia_usdt_value = 169; // Two decimals.
            let dia_usdt_timestamp = 1635454933;

            // Set value for transaction sender.
            Dia::setValue<DIA, USDT>(&account, dia_usdt_value, dia_usdt_timestamp);

            let (btc_usdt_v, btc_usdt_t) = Dia::getValue<BTC, USDT>(acc_addr);
            let (dia_usdt_v, dia_usdt_t) = Dia::getValue<DIA, USDT>(acc_addr);

            assert(btc_usdt_v == btc_usdt_value, 101);
            assert(btc_usdt_t == btc_usdt_timestamp, 102);
            
            assert(dia_usdt_v == dia_usdt_value, 201);
            assert(dia_usdt_t == dia_usdt_timestamp, 202);
        }
    }
}