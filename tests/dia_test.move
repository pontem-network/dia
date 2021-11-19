address {{sender}} {
    module DiaTest {
        use 0x1::Signer;
        use 0x1::DiemAccount;
        use {{sender}}::Initializer;
        use {{sender}}::Dia;
        use {{sender}}::DiaCurrencies::{BTC, USDT, DIA};
    
        /// Errors.
        const EVALUE_NOT_MATCH: u64 = 101;
        const ETS_NOT_MATCH: u64 = 102;

        fun initialize_test(dr: &signer, tr: &signer, account: &signer) {
            Initializer::initialize(dr, tr, 101);
            Initializer::register_currency<BTC>(dr, b"BTC");
            Initializer::register_currency<USDT>(dr, b"USDT");
            Initializer::register_currency<DIA>(dr, b"DIA");

            DiemAccount::create_parent_vasp_account<BTC>(tr, Signer::address_of(account), x"", x"", true);
        }

        #[test(
            dr = @0xA550C18,
            tr = @0xB1E55ED,
            account = @5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY,
        )]
        /// Test set value.
        fun test_set_value(dr: signer, tr: signer, account: signer) {
            initialize_test(&dr, &tr, &account);

            let acc_addr = Signer::address_of(&account);

            // value and timestamp.
            let value = 6120223; // Two decimals.
            let timestamp = 1635454933;

            // Set value for transaction sender.
            Dia::setValue<BTC>(&account, value, timestamp);

            // Get value and match.
            let (v, t) = Dia::getValue<BTC>(acc_addr);

            assert(v == value, EVALUE_NOT_MATCH);
            assert(t == timestamp, ETS_NOT_MATCH);
        }


        #[test(
            dr = @0xA550C18,
            tr = @0xB1E55ED,
            account = @5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY,
        )]
        /// Test rewrite value.
        fun test_rewrite_value(dr: signer, tr: signer, account: signer) {
            initialize_test(&dr, &tr, &account);

            let acc_addr = Signer::address_of(&account);

            // value and timestamp.
            let value = 6120223; // Two decimals.
            let timestamp = 1635454933;

            // Set value for transaction sender.
            Dia::setValue<BTC>(&account, value, timestamp);

            // Get value and match.
            let (v, t) = Dia::getValue<BTC>(acc_addr);

            assert(v == value, 101);
            assert(t == timestamp, 102);

            // New values.
            let new_value = 6119855;
            let new_timestamp = 1635455000;

            Dia::setValue<BTC>(&account, new_value, new_timestamp);

            // Get new values and match.
            let (new_v, new_t) = Dia::getValue<BTC>(acc_addr);

            assert(new_v == new_value, EVALUE_NOT_MATCH);
            assert(new_t == new_timestamp, ETS_NOT_MATCH);
        }


        // Different currencies.
        #[test(
            dr = @0xA550C18,
            tr = @0xB1E55ED,
            account = @5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY,
        )]
        fun test_diff_curr(dr: signer, tr: signer, account: signer) {
            initialize_test(&dr, &tr, &account);

            let acc_addr = Signer::address_of(&account);

            // value and timestamp.
            let btc_value = 6120223; // Two decimals.
            let btc_timestamp = 1635454933;

            // Set value for transaction sender.
            Dia::setValue<BTC>(&account, btc_value, btc_timestamp);

            // value and timestamp.
            let dia_value = 169; // Two decimals.
            let dia_timestamp = 1635454933;

            // Set value for transaction sender.
            Dia::setValue<DIA>(&account, dia_value, dia_timestamp);

            let (btc_v, btc_t) = Dia::getValue<BTC>(acc_addr);
            let (dia_v, dia_t) = Dia::getValue<DIA>(acc_addr);

            assert(btc_v == btc_value, 101);
            assert(btc_t == btc_timestamp, 102);
            
            assert(dia_v == dia_value, 201);
            assert(dia_t == dia_timestamp, 202);
        }
    }
}
