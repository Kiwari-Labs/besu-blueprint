# Loyalty Program Blueprint

A blueprint for building Loyalty Program with [hyperledger/besu](https://github.com/hyperledger/besu)

## Specification

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “NOT RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in RFC 2119 and RFC 8174.

### Network Parameter and Configuration

> [!NOTE]  
> `mainnet` is network for production use.  
> `testnet` is network for develop and staging use.

| Parameter    | Mainnet                   | Testnet                   |
| ------------ | ------------------------- | ------------------------- |
| NETWORK_NAME | `Loyalty Program Mainnet` | `Loyalty Program Testnet` |
| CHAIN_ID     | `4062100861`              | `116687680`               |
| CHAIN_ID_HEX | `0xf21ebd7d`              | `116687680`               |
| SYMBOL       | `LP`                      | `tLP`                     |
| BLOCK_PERIOD | `3` seconds               | `12` seconds              |

If including latency of network, other service etc. (`~3` seconds). User may wait up to `6` seconds for `mainnet` and `15` seconds for `testnet`.

> [!NOTE]
> `CHAIN_ID` generate form CRC-32/ISO hash of `NETWORK_NAME`/

The network **RECOMMENDED** to operate without a native token means no transaction fee on this network.  
However, it still **REQUIRED** a currency `SYMBOL` for functional representation for related system or application e.g. wallet, block explorer and other.

### Node Type and Hardware Requirement

|              | Mainnet (Validator)        | Mainnet (RPC) | Mainnet (Boot) | Testnet (Validator)        | Testnet (RPC) | Testnet (Boot) |
| ------------ | -------------------------- | ------------- | -------------- | -------------------------- | ------------- | -------------- |
| **CPU**      | 8 cores @ high clock speed | 4 cores       | 2 cores        | 2 cores @ high clock speed | 2 cores       | 1 core         |
| **Memory**   | 128 GB                     | 64 GB         | 4 GB           | 4 GB                       | 2 GB          | 1 GB           |
| **Storage**  | 1 TB                       | 2 TB          | 500 GB         | 100 GB                     | 250 GB        | 50 GB          |
| **Internet** | 100 Mb/s                   | 100 Mb/s      | 100 Mb/s       | 25 Mb/s                    | 25 Mb/s       | 25 Mb/s        |

> [!NOTE]
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

Some instance models **MAY** not exactly meet the hardware requirements mentioned above but have been chosen for cost-effectiveness and resource optimization in relation to the tasks of each node.

| Node Type  | Recommended | Minimum |
| ---------- | ----------- | ------- |
| validators | 8           | 4       |
| boot       | 4           | 2       |
| rpc        | n > 2       | 2       |

### Example Client Configuration

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

### ERC standard for each asset class on the network

- [ERC-20]() for loyalty point without expiration mechanism
- [ERC-7818]() for loyalty point with expiration mechanism.
- [ERC-7818]() with decimal set to `0` and extending [ERC-1046]() for simple/essential voucher or coupon.
- [ERC-7858]() for unique voucher or coupon.

### Mitigate ERC-7818 sorted list limitation

To mitigate high `gasUsed` when maintaining large sorted list **REQUIRED** adding stateful precompiled contract to `hyperledger/besu` client. Source code of forked `hyperledger/besu` that implementing stateful precompiled contract can be found [here](https://github.com/Kiwari-labs/besu).

### Expanding Loyalty Point / Voucher across network

For expanding Loyalty point or voucher to other blockchain network seem to be challenge due to the Loyalty point might be expirable and lost overtime on origin network. However, it can be done by ...

source code of all service contracts are store at [monorepo-service-contracts](https://github.com/Kiwari-labs/monorepo-service-contracts)

> [!WARNING]
> `stateful-precompile-contract` and `service-contracts` are under Development may change in the future.

### Run example network with the docker-compose

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

### Copyright

Copyright 2024 Kiwari Labs Licensed under the [BUSL-1.1](../LICENSE-BUSL).
