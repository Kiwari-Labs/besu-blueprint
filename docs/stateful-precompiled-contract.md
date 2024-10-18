---
title: Guidance to implementing a stateful precompiled Contract
description: A Guidance to implementing a stateful precompiled smart contract for executing complexity task.
author: sirawt (@MASDXI)
status: Draft
---

## Simple Summary

Guidance for implementing custom stateful precompiled contracts to handle complex, resource-intensive tasks efficiently on a blockchain network. These contracts allow operations that are beyond the computational limits of traditional smart contracts, using the native speed of the client’s underlying software.

## Abstract

A stateful precompiled contract can be a key feature that sets your blockchain network apart from others.  
Adding a stateful precompiled contract to your client is an approach that surpasses the limitations of the `EVM` and or `non-EVM` smart contracts by enabling the processing of large-scale and complex operations with the native speed of your client’s language.

## Motivation

The Virtual Machine acts as a virtual processor to execute transactions on the blockchain. To extend its capabilities, the virtual processor can benefit from a virtual co-processor, which functions as a specialized unit designed to handle more complex or computationally intensive tasks. This co-processor, in the form of a precompiled contract, allows for more efficient execution of operations such as cryptographic functions, large-scale data processing, and state management. By offloading these tasks to the virtual co-processor, the main processor (VM) can focus on simpler operations, enhancing overall system performance and reducing `gas` costs.

## Rationale

- Outside the Runtime Environment: Traditional smart contracts, written in `Solidity` or `Vyper` and executed in the `EVM` for other blockchain also often limited by `gas` costs and computational overhead. Precompiled contracts offer a way to execute computationally intensive tasks more efficiently because they are directly implemented in the client software, bypassing some of the overhead imposed by the `EVM` or `Virtual Machine` layer. Some operations, such as cryptographic functions, heavy and high precision arithmetic operation or large-scale data processing, are computationally expensive (require high `gas`/transaction fee) or slow when implemented in smart contracts can't executed under network `blocktime` frame. A precompiled contract allows these operations to be handled natively by the client in a more efficient programming language (e.g., C++, Rust, Go, or Other).
- State Management: By incorporating stateful logic into the precompiled contract, developers gain the ability to maintain and manipulate contract-specific data across multiple transactions. This enables the creation of more dynamic and powerful blockchain applications that can handle complex operations and state transitions efficiently.

Some potential use cases for stateful precompiled contracts include

Order Book Decentralized Exchange (DEX) enabling complex functionalities such as order matching and tracking for DEX.  
Near Real-time Application and Internet Of Things  off-load the blockchain by integrating to external data and services

## Guideline

#### Determining the Custom Precompiled Contract Address

This section explains how the address of the custom precompiled contract, `CONTRACT_ADDRESS`, is calculated.

``` python
# ethereum style hex representation 
bytes(keccak256("<CONTRACT_NAME>") , 20)
bytes(ripemd160("<CONTRACT_NAME>") , 20)
bytes(sha256("<CONTRACT_NAME>") , 20)
bytes(blake2b("<CONTRACT_NAME>"),20)
bytes(blake3("<CONTRACT_NAME>"),20)
```

**Note** adopting `blake2b` or `blake3` for calculating storage slots in stateful precompiled contracts, as opposed to using `keccak256`, can improve efficiency and speed.  
  related link
  - polkadot academy cryptography [hashes](https://polkadot-blockchain-academy.github.io/pba-book/cryptography/hashes/page.html)
  - crypto stack exchange question [#31674](https://crypto.stackexchange.com/questions/31674/what-advantages-does-keccak-sha-3-have-over-blake2)

``` python
# bitcoin style base58 representation
base58(sha256("<CONTRACT_NAME>"),"<PREFIX>")
```

1. Hashing the contract name hashed using the `keccak256` or hex representation algorithm for `EVM`.
2. Extract the address from hash by converted to a string, and the first 20 characters are taken as the contract's address for `EVM` based blockchain.  
   > This method ensures a unique and consistent address for the stateful precompiled contract based on its name.

#### Calculate Storage Slot for Stateful Precompiled Contract

- storage slot style  
> // TODO

- wide column style  
> // TODO

- other style  
> // TODO

## Security Considerations

- [SC04:Improper Access Control](https://owasp.org/www-project-smart-contract-top-10/2023/en/src/SC04-access-control-vulnerabilities.html) If a stateful or stateless precompiled contract isn’t securely and correctly implemented when connecting to external services,  
it may lead to unauthorized access and inappropriate usage, potentially increasing the risk and exposure of the external service connected to the smart contract.
- [SWC136:Unencrypted Private Data On-Chain](https://swcregistry.io/docs/SWC-136/) Utilizing a custom stateful or stateless precompiled contract that interacts directly with external systems to acquire data may lead to storing sensitive information on-chain. If this data is stored without proper encryption or protection,  
it could expose private or sensitive information to unauthorized parties, violating privacy and security standards.
- [SWC124:Write to Arbitrary Storage Location](https://swcregistry.io/docs/SWC-124/) Using an alternate hash function instead of `keccak256` for storage slot calculations could potentially expose vulnerabilities, such as writing to arbitrary storage locations,  
Ensuring the integrity and collision resistance of the hash function is critical for preventing unintended overwriting or access to storage areas
- The precompiled contract has potential takes too long to execute, exceeding the block's execution time frame limit.

---
#### Historical links related to this standard

- Technical Document from `solidity` [Documents](https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html)
- Technical Document from `!Ink` [Documents](https://use.ink/4.x/datastructures/storage-layout)
- Article from Avalanche [Customizing the EVM with Stateful Precompiles](https://medium.com/avalancheavax/customizing-the-evm-with-stateful-precompiles-f44a34f39efd)
- Article from AppLayer [Stateful Precompiles: EVM Game Changers or Another Overhyped Complexity?](https://medium.com/@AppLayerLabs/stateful-precompiles-evm-game-changers-or-another-overhyped-complexity-b064145b290e)
- Article from knauss [Precompiles & stateful precompiles](https://knauss.dev/posts/sixteenth-post/)
- Example Implementation `Native ERC20` contract from [moonbeam/moonriver](https://docs.moonbeam.network/builders/ethereum/precompiles/ux/erc20/)

#### Appendix
**Virtual Processor** definition A virtual processor is a representation of a physical processor core to the operating system of a logical partition that uses shared processors.  
**Co-Processor** definition a microprocessor designed to supplement the capabilities of the primary processor.  
**EVM** definition Ethereum Virtual Machine
**Gas** definition transaction costs on the Ethereum blockchain or other blockchain that borrowing the concept.  
**Hex** definition Hexadecimal  
**Stateful** definition applications or process that allow users to store and retrieve information and processes over time.  
**Stateless** definition applications or process that do not store any information about previous interactions. Each user request is treated independently, meaning the system does not retain any data from prior sessions.

## License
Release under the [MIT](LINCENSE-MIT) license.   
Copyright (C) to author. All rights reserved.