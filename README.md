# Dia Smart Contracts

[Dia Protocol](https://www.diadata.org/) smart contracts rewritten in Move language.

Requirements:

* [Dove](https://github.com/pontem-network/move-tools)

Checklist:

* ✅ Contracts: Dia and test currencies.
* ✅ Tests.
* ✅ Events - still in progress.

## Build

    dove build

After, see `artifacts` folder for compiled files.

### Tests

    dove test

See [tests](./tests/dia_test.move) for details.

### Deployment

You should have PONT tokens on your account.

Replace/add your Pontem address in Dove.toml with address of your own account:

    account_address = "your address"

Build modules:

    dove build

Create your account inside Diem Standard Library, if you haven't created one yet:

    dove tx 'create_account(tr, <your address>)'

Replace `<your address>` with the correct one, it's important to use the same account address you are going to use to update oracle values.

Execute transaction:

    polkadot-js-api tx.mvm.execute @./artifacts/transactions/create_account.mvt 100000 --seed "<seed>" --ws <ws>

Where:

    * `seed` - seed from your account.
    * `ws` - address of Websocket endpoint. In case of Pontem testnet it's `wss://testnet.pontem.network/ws`.


Deploy Dia.move module:

    polkadot-js-api tx.mvm.publishModule @./artifacts/modules/1_Dia.mv 100000 --seed "<seed>" --ws <ws>

Where:

    * `seed` - seed from your account.
    * `ws` - address of Websocket endpoint. In case of Pontem testnet it's `wss://testnet.pontem.network/ws`.

The contracts should be available on `your_address::Dia`.

### LICENSE 

MIT.
