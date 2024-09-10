# Merit Network

[Merit](https://meritnet.io) is a DLT-based Loyalty Platform that use [hyperledger/besu](https://github.com/hyperledger/besu)

### Network Parameter and Configuration

| Parameter    | Mainnet                                | Testnet                                |
| ------------ | -------------------------------------- | -------------------------------------- |
| NETWORK_NAME | `Merit`                                | `Merit Testnet`                        |
| CHAIN_ID     | `776982`                               | `116776982`                            |
| SYMBOL       | `MER`                                  | `tMER`                                 |
| RPC_URL      | `https://meritnet.rpc.mainnet.io`      | `https://meritnet.rpc.testnet.io`      |
| EXPLORER_URL | `https://meritnet.explorer.mainnet.io` | `https://meritnet.explorer.testnet.io` |
| BLOCK_PERIOD | `3` seconds                            | `12` seconds                           |

`mainnet` is stand for production.  
`testnet` is stand develop and staging.

**`CHAIN_ID` generate form ASCII code of the `SYMBOL`**  
**The network operates without a native token for transaction fees and is built as a zero-transaction fee system.  
However, it still requires a currency symbol for functional representation for third-party wallet application like metamask, rabbit and other.**

### Node Type and Hardware Requirement

|              | Mainnet (Validator)        | Mainnet (RPC) | Mainnet (Boot) | Testnet (Validator)        | Testnet (RPC) | Testnet (Boot) |
| ------------ | -------------------------- | ------------- | -------------- | -------------------------- | ------------- | -------------- |
| **CPU**      | 8 cores @ high clock speed | 4 cores       | 2 cores        | 2 cores @ high clock speed | 2 cores       | 1 core         |
| **Memory**   | 128 GB                     | 64 GB         | 4 cores        | 4 GB                       | 2 GB          | 1 GB           |
| **Storage**  | 1 TB                       | 2 TB          | 500 GB         | 100 GB                     | 250 GB        | 50 GB          |
| **Internet** | 100 Mb/s                   | 100 Mb/s      | 100 Mb/s       | 25 Mb/s                    | 25 Mb/s       | 25 Mb/s        |

**Note:**

- **CPU:** Focus on high clock speed rather than core count for optimal performance. A high clock speed, typically above 3.0 GHz
- **Storage:** SSD is recommended for faster data access and better overall performance.
- **RPC:** is running as archive node not pruning any data.

  | Node Type  | Minimum | Recommended |
  | ---------- | ------- | ----------- |
  | validators | 4       | 8           |
  | boot       | 2       | 4           |
  | rpc        | 2       | n > 2       |

  The `[experiment]` section in the `config.toml` can be used to fine-tune network performance based on your specific deployment requirements.

### Keys differentiate from other `hyperledger/besu` network

```text
🚧 Under construction and development.
```

Transaction Validation: based from [`Consensys/permissioning-smart-contracts`](https://github.com/Consensys/permissioning-smart-contracts) but add additional capabilities.

- `rootAddress` can be able to `granted` or `revoked` other role.
- `developerAddress` can be able to `deploy` the smart contract with threshold limit and `call` to any address.
- `serviceAddress`/`agentAddress` can be able only to `call` to `address` or `contract` that registered.
- `clientAddress` can not able to `deploy` but can only `call` to `address` or `contract` that registered.  
  source code [repository](https://github.com/Kiwari-labs)

Stateful Precompiled Contract

- `LinkedListStatefulPrecompiledContract` at address `0xe2a2256098eafc2dd3b907c81d9719d4f569b6c2`  
  source code [repository](https://github.com/Kiwari-labs)

Smart Contract

- `AssetFactory`
- `CampaignFactory`  
  source code [repository](https://github.com/Kiwari-labs)

### Run example network with docker-compose

command to start example network

```sh
./docker-compose-up.sh
```

command to stop example network

```sh
docker-compose stop
```

command to clean up and reset network

```sh
./docker-compose-down.sh
```

### Support and Issue

For support or any inquiries, feel free to reach out to us at [github-issue]() or kiwarilabs@protonmail.com

### License

This project is licensed under the BSL-1.1 License. See the [LICENSE](LICENSE) file for more details.
