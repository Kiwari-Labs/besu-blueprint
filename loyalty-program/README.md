# Loyalty Program

DLT-based Loyalty Platform (DLP) that use [hyperledger/besu](https://github.com/hyperledger/besu)

### Network Parameter and Configuration

> [!TIP]  
>`mainnet` is network for production use.  
> `testnet` is network for develop and staging use.
> Table below is suggestion for deploying private network for Loyalty Program use case.

| Parameter    | Mainnet                                        | Testnet                                        |
| ------------ | ---------------------------------------------- | ---------------------------------------------- |
| NETWORK_NAME | `DLP`                                          | `DLP Testnet`                                  |
| CHAIN_ID     | `687680`                                       | `116687680`                                    |
| SYMBOL       | `DLP`                                          | `tDLP`                                         |
| RPC_URL      | `https://dlp-rpc-mainnet.domain.com`           | `https://dlp-rpc-testnet.domain.com`           |
| EXPLORER_URL | `https://dlp-blockexplorer-mainnet.domain.com` | `https://dlp-blockexplorer-testnet.domain.com` |
| BLOCK_PERIOD | `3` seconds                                    | `12` seconds                                   |
| TOKEN_LOGO   | `none`                                         | `none`                                         |
| NETWORK_LOGO | `none`                                         | `none`                                         |

If including latency of network, other service and etc (`~3` seconds). user may wait up to `6` seconds for mainnet and `15` seconds for testnet.

> [!NOTE]
> `CHAIN_ID` generate form ASCII code of the `SYMBOL`  
> The network operates without a native token for transaction fees and is built as a zero-transaction fee system.  
> However, it still requires a currency symbol for functional representation for third-party wallet application like  
> metamask, rabbit, block explorer and other.

### Node Type and Hardware Requirement

|              | Mainnet (Validator)        | Mainnet (RPC) | Mainnet (Boot) | Testnet (Validator)        | Testnet (RPC) | Testnet (Boot) |
| ------------ | -------------------------- | ------------- | -------------- | -------------------------- | ------------- | -------------- |
| **CPU**      | 8 cores @ high clock speed | 4 cores       | 2 cores        | 2 cores @ high clock speed | 2 cores       | 1 core         |
| **Memory**   | 128 GB                     | 64 GB         | 4 GB           | 4 GB                       | 2 GB          | 1 GB           |
| **Storage**  | 1 TB                       | 2 TB          | 500 GB         | 100 GB                     | 250 GB        | 50 GB          |
| **Internet** | 100 Mb/s                   | 100 Mb/s      | 100 Mb/s       | 25 Mb/s                    | 25 Mb/s       | 25 Mb/s        |

> [!TIP]
> - **CPU:** Focus on high clock speed rather than core count for optimal performance. A high clock speed, typically above 3.0 GHz
> - **Storage:** SSD is recommended for faster data access and better overall performance.
> - **RPC:** is running as archive node not pruning any data.
  

### Cloud Service Provider Instance Models/Series

|                    | Mainnet (Validator) | Mainnet (RPC)    | Mainnet (Boot)  | Testnet (Validator) | Testnet (RPC)   | Testnet (Boot)       |
| ------------------ | ------------------- | ---------------- | --------------- | ------------------- | --------------- | -------------------- |
| Alibaba Cloud      | `ecs.r8a.4xlarge`   | `ecs.g8.2xlarge` | `ecs.g6.large`  | `ecs.g6.large`      | `ecs.c6.large`  | `ecs.t5-lc1m1.small` |
| Amazon Web Service | `r6i.4xlarge`       | `r6i.2xlarge`    | `c5a.large`     | `c5a.large`         | `c7a.medium`    | `t3.micro`           |
| Huawei Cloud       | `ai7.4xlarge.8`     | `ai7.2xlarge.8`  | `h3.large.2`    | `h3.large.2`        | `s6.large.2`    | `s6.small.1`         |
| Microsoft Azure    | `E16ds_v5`          | `E8ds_v5`        | `D2as_v5`       | `D2as_v5`           | `F2s_v2`        | `A1_v2`              |
| Google Cloud       | `n2-highmem-16`     | `n2-highmem-8`   | `n2-standard-2` | `n2-standard-2`     | `n2-standard-1` | `e2-micro`           |
| IBM Cloud          | `bx2-16x64`         | `bx2-8x32`       | `bx2-2x8`       | `bx2-2x8`           | `bx2-2x4`       | `bx2-1x2`            |

> [!NOTE]
> Some instance models may not exactly meet the hardware requirements  mentioned above but have been chosen for cost-effectiveness and resource optimization in relation to the tasks of each node.

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

### Keys differentiate from official `hyperledger/besu` client

System Contract Waiving Transaction Fee

- `WaivingTransactionFeeContract` at address 
`0xfcd36b9911ea5844070581a577ae85b5457a3897` which is generate from `keccak256(name).toBytes().slice(0, 20)`

Stateful Precompiled Contract

- `LinkedListStatefulPrecompiledContract` at address 
`0x12bb07c003ca88db19f4301cdf2addeb9fe4c93f` which is generate from `keccak256(name).toBytes().slice(0, 20)`

source code of forked `hyperledger/besu` that implementing system contract and stateful precompiled can be found on [repository](https://github.com/Kiwari-labs/besu)

Service Smart Contract

| Contract Name                 | Mainnet Address (desirable)                  | Testnet Address (desirable)                  |
| ----------------------------- | -------------------------------------------- | -------------------------------------------- |
| `PointTokenFactoryContract`   | `0x572d9d345fea6750819481012750b2440a10e8cb` | `0xc6fb65bf5fea6750819481012750b2440a10e8cb` |
| `VoucherTokenFactoryContract` | `0x572d9d34f832fd4da900ed5f68e4d87ab54cf3e0` | `0xc6fb65bff832fd4da900ed5f68e4d87ab54cf3e0` |
| `CouponTokenFactoryContract`  | `0x572d9d34d8cc7479330f22cf9b849fdc3722ff7e` | `0xc6fb65bfd8cc7479330f22cf9b849fdc3722ff7e` |
| `CampaignFactoryContract`     | `0x572d9d3422bdb2a4e032cbfb3420eb569470fb19` | `0xc6fb65bf22bdb2a4e032cbfb3420eb569470fb19` |
| `AgreementFactoryContract`    | `0x572d9d34d35e0a6dae42c724a1c1335b3a36d599` | `0xc6fb65bfd35e0a6dae42c724a1c1335b3a36d599` |
| `OtherContract`               | `0x572d9d34d35`                              | `0xc6fb65bf`                                 |

> [!NOTE]
> The deployed address may differ from the desired one if it is manually deployed from an externally owned account (EOA) and not specified as a pre-deployed contract in the genesis configuration file.  
> `ERC721` and `ERC1155` may suitable for both voucher and coupon.

source code of each service contracts are store at [monorepo-service-contracts](https://github.com/Kiwari-labs/monorepo-service-contracts)

> [!WARNING]
> `stateful-precompile-contract` and `service-contracts` are under Development may change in the future.

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

This repository is released under the [BUSL-1.1](../LICENSE-BUSL).  
Copyright (C) Kiwari Labs. All rights reserved.
