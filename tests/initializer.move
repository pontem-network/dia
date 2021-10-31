address {{sender}} {
/// Module initiales Diem dependencies.
/// Use it in your project in case you want to initialize Diem dependencies.
module Initializer {
    use 0x1::AccountFreezing;
    use 0x1::ChainId;
    use 0x1::DualAttestation;
    use 0x1::Diem;
    use 0x1::DiemAccount;
    use 0x1::DiemBlock;
    use 0x1::DiemConfig;
    use 0x1::DiemSystem;
    use 0x1::DiemTimestamp;
    use 0x1::DiemVersion;
    use 0x1::TransactionFee;
    use 0x1::PONT;
    use 0x1::FixedPoint32;
    use 0x1::AccountLimits;

    struct Drop<C: store + key> has key, store {
        mint_cap: Diem::MintCapability<C>,
        burn_cap: Diem::BurnCapability<C>,
    }

    public fun initialize(dr_account: &signer, tc_account: &signer, chain_id: u8) {
        DiemAccount::initialize(dr_account, x"");
        ChainId::initialize(dr_account, chain_id);
        
        // On-chain config setup
        DiemConfig::initialize(dr_account);
        // Currency setup
        Diem::initialize(dr_account);
        // Currency setup
        PONT::initialize(dr_account, tc_account);
        AccountFreezing::initialize(dr_account);
        TransactionFee::initialize(tc_account);

        DiemSystem::initialize_validator_set(
            dr_account,
        );
        DiemVersion::initialize(
            dr_account,
        );
        DualAttestation::initialize(
            dr_account,
        );
        DiemBlock::initialize_block_metadata(dr_account);

        DiemTimestamp::set_time_has_started(dr_account);
    }

    public fun register_currency<C: key + store>(dr: &signer, code: vector<u8>) {
            let (mint_cap, burn_cap) = Diem::register_native_currency<C>(
            dr,
            FixedPoint32::create_from_rational(1, 1), // exchange rate to PONT
            10000000000, // scaling_factor = 10^10
            10000000000, // fractional_part = 10^10
            copy code,
            code
        );

        AccountLimits::publish_unrestricted_limits<C>(dr);  

        move_to(dr, Drop {
            mint_cap,
            burn_cap
        });
    }
}
}
