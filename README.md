# Merit Network

[Merit](https://meritnet.io) is a DLT-based Loyalty Platform that use [hyperledger/besu](https://github.com/hyperledger/besu)

### Network Parameter and Configuration

`mainnet` is stand for production.  
`testnet` is stand develop and staging.

| Parameter    | Mainnet                                | Testnet                                |
| ------------ | -------------------------------------- | -------------------------------------- |
| NETWORK_NAME | `Merit`                                | `Merit Testnet`                        |
| CHAIN_ID     | `776982`                               | `116776982`                            |
| SYMBOL       | `MER`                                  | `tMER`                                 |
| RPC_URL      | `https://meritnet.rpc.mainnet.io`      | `https://meritnet.rpc.testnet.io`      |
| EXPLORER_URL | `https://meritnet.explorer.mainnet.io` | `https://meritnet.explorer.testnet.io` |
| BLOCK_PERIOD | `3` second                             | `12` seconds                           |
| TOKEN_LOGO   | `none`                                 | `none`                                 |
| NETWORK_LOGO | `none`                                 | `none`                                 |

If including latency of network, other service and etc (`~3` seconds). user may wait up to `6` seconds for mainnet and `15` seconds for testnet.

**`CHAIN_ID` generate form ASCII code of the `SYMBOL`**  
**The network operates without a native token for transaction fees and is built as a zero-transaction fee system.  
However, it still requires a currency symbol for functional representation for third-party wallet application like metamask, rabbit, block explorer and other.**

### Node Type and Hardware Requirement

|              | Mainnet (Validator)        | Mainnet (RPC) | Mainnet (Boot) | Testnet (Validator)        | Testnet (RPC) | Testnet (Boot) |
| ------------ | -------------------------- | ------------- | -------------- | -------------------------- | ------------- | -------------- |
| **CPU**      | 8 cores @ high clock speed | 4 cores       | 2 cores        | 2 cores @ high clock speed | 2 cores       | 1 core         |
| **Memory**   | 128 GB                     | 64 GB         | 4 GB           | 4 GB                       | 2 GB          | 1 GB           |
| **Storage**  | 1 TB                       | 2 TB          | 500 GB         | 100 GB                     | 250 GB        | 50 GB          |
| **Internet** | 100 Mb/s                   | 100 Mb/s      | 100 Mb/s       | 25 Mb/s                    | 25 Mb/s       | 25 Mb/s        |

**Note:**

- **CPU:** Focus on high clock speed rather than core count for optimal performance. A high clock speed, typically above 3.0 GHz
- **Storage:** SSD is recommended for faster data access and better overall performance.
- **RPC:** is running as archive node not pruning any data.

### Cloud Service Provider Instance Models/Series

|                    | Mainnet (Validator) | Mainnet (RPC)    | Mainnet (Boot)  | Testnet (Validator) | Testnet (RPC)   | Testnet (Boot)       |
| ------------------ | ------------------- | ---------------- | --------------- | ------------------- | --------------- | -------------------- |
| Alibaba Cloud      | `ecs.r8a.4xlarge`   | `ecs.g8.2xlarge` | `ecs.g6.large`  | `ecs.g6.large`      | `ecs.c6.large`  | `ecs.t5-lc1m1.small` |
| Amazon Web Service | `r6i.4xlarge`       | `r6i.2xlarge`    | `c5a.large`     | `c5a.large`         | `c7a.medium`    | `t3.micro`           |
| Huawei Cloud       | `ai7.4xlarge.8`     | `ai7.2xlarge.8`  | `h3.large.2`    | `h3.large.2`        | `s6.large.2`    | `s6.small.1`         |
| Microsoft Azure    | `E16ds_v5`          | `E8ds_v5`        | `D2as_v5`       | `D2as_v5`           | `F2s_v2`        | `A1_v2`              |
| Google Cloud       | `n2-highmem-16`     | `n2-highmem-8`   | `n2-standard-2` | `n2-standard-2`     | `n2-standard-1` | `e2-micro`           |
| IBM Cloud          | `bx2-16x64`         | `bx2-8x32`       | `bx2-2x8`       | `bx2-2x8`           | `bx2-2x4`       | `bx2-1x2`            |

**Note:** Some instance models may not exactly meet the hardware requirements mentioned above but have been chosen for cost-effectiveness and resource optimization in relation to the tasks of each node.

| Node Type  | Recommended | Minimum |
| ---------- | ----------- | ------- |
| validators | 8           | 4       |
| boot       | 4           | 2       |
| rpc        | n > 2       | 2       |

The `[experiment]` section in the `config.toml` can be used to fine-tune network performance based on your specific deployment requirements, see [performance troubleshooting guideline](https://besu.hyperledger.org/public-networks/how-to/troubleshoot/performance).

`mainnet` performance configuration guidance based on recommendation specification.

```toml
[experiment-validator]
Xplugin-rocksdb-max-open-files = 10240
Xplugin-rocksdb-cache-capacity = 10737418240
Xplugin-rocksdb-background-thread-count = 8
Xplugin-rocksdb-high-spec-enabled = true

[experiment-rpc]
Xplugin-rocksdb-max-open-files = 8192
Xplugin-rocksdb-cache-capacity = 5368709120
Xplugin-rocksdb-background-thread-count = 4
Xplugin-rocksdb-high-spec-enabled = true
```

### Keys differentiate from other `hyperledger/besu` network

```text
🚧 Under construction and development.
```

Stateful Precompiled Contract

- `LinkedListStatefulPrecompiledContract` at address `0xe2a2256098eafc2dd3b907c81d9719d4f569b6c2`

source code of stateful precompiled can be found on [repository](https://github.com/Kiwari-labs/besu)

Smart Contract

| Contract Name              | Mainnet Address | Testnet Address |
| -------------------------- | --------------- | --------------- |
| `AssetFactoryContract`     | `0x`            | `0x`            |
| `CampaignFactoryContract`  | `0x`            | `0x`            |
| `AgreementFactoryContract` | `0x`            | `0x`            |

**Note:** deployed address can be desirable if use pre-deploy contract in genesis configuration file.

source code of each smart contract

- token-service-contracts [repository](https://github.com/Kiwari-labs/token-service-contracts)
- token-exchange-contracts [repository](https://github.com/Kiwari-labs/token-exchagne-contracts)

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

For support or any inquiries, feel free to reach out to us at [github-issue](https://github.com/Kiwari-labs/) or kiwarilabs@protonmail.com

### License

This project is licensed under the BSL-1.1 License. See the [LICENSE](LICENSE) file for more details.
