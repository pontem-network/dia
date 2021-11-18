script {
    use 0x1::DiemAccount;
    use 0x1::PONT::PONT;

    fun create_account(tc_account: signer, account: address) {
        DiemAccount::create_parent_vasp_account<PONT>(
            &tc_account, // Treasury signature.
            account, // Address of account.
            x"", // Auth key, ignore for now.
            x"446961", // Account name, hex (Dia)
            true // Support all currencies
        );
    }
}
