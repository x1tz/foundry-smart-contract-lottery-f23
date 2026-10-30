## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

For Sepolia, use standard Foundry with support for `--hardfork amsterdam` (tested
with v1.8.3). The older zkSync build underestimates gas after Sepolia's
[Glamsterdam upgrade on October 6, 2026](https://blog.ethereum.org/en/2026/09/17/glamsterdam-testnet-announcement).
`evm_version` controls the compiler target; `--hardfork amsterdam` selects the
runtime gas rules for simulation and estimation.

Set `SEPOLIA_RPC_URL` and `ETHERSCAN_API_KEY` in `.env`, and use the keystore
account named `default` (or set `SEPOLIA_ACCOUNT`):

```shell
foundryup
forge --version
make simulate-sepolia
make deploy-sepolia
```

The simulation target does not send transactions or unlock the keystore.
Deployment uses `--slow` so that consumer registration is sent only after the
Raffle deployment succeeds. `FORGE=/path/to/forge` can select a separate Foundry
installation without changing the global toolchain.

If a previous deployment reverted and its transactions were mined, start a fresh
deployment; those transactions have already consumed their nonces. An address
printed for a failed creation has no deployed contract code.

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
