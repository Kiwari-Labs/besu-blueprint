---
title: Guidance to implementing custom precompiled Contract
description: A Guidance to implementing a custom precompiled smart contract for executing complexity task.
author: sirawt (@MASDXI)
status: Draft
---

## Simple Summary

## Abstract

A stateful precompiled contract can be a key feature that sets your blockchain network apart from others.  
Adding a stateful precompiled contract to your client is an approach that surpasses the limitations of the EVM and  
traditional smart contracts by enabling the processing of large-scale and complex operations with the native speed of your client’s language.

## Motivation

- Extending capabilities of the smart contract

## Rationale

- Stateless Precompiled Contract
- Stateful Precompiled Contract

## Specification

#### Determining the Custom Precompiled Contract Address

This section explains how the address of the custom precompiled contract, `CONTRACT_ADDRESS`, is calculated.

```
var contractAddress = keccak256("<CONTRACT_NAME>").toString().slice(0, 20)
```

1. Hash the Contract Name: The contract name is hashed using the keccak256 algorithm.
2. Extract the Address: The resulting hash is then converted to a string, and the first 20 characters are taken as the contract's address.  
   This method ensures a unique and consistent address for the stateful precompiled contract based on its name.

#### Calculate Storage Slot for Stateful Precompiled Contract


## Security Considerations

- [SC04:Improper Access Control](https://owasp.org/www-project-smart-contract-top-10/2023/en/src/SC04-access-control-vulnerabilities.html) If a stateful or stateless precompiled contract isn’t securely and correctly implemented when connecting to external services, it may lead to unauthorized access and inappropriate usage, potentially increasing the risk and exposure of the external service connected to the smart contract.
- [SWC136:Unencrypted Private Data On-Chain](https://swcregistry.io/docs/SWC-136/) Utilizing a custom stateful or stateless precompiled contract that interacts directly with external systems to acquire data may lead to storing sensitive information on-chain. If this data is stored without proper encryption or protection, it could expose private or sensitive information to unauthorized parties, violating privacy and security standards.
- [SWC124:Write to Arbitrary Storage Location](https://swcregistry.io/docs/SWC-124/) Using an alternate hash function instead of `keccak256` for storage slot calculations could potentially expose vulnerabilities, such as writing to arbitrary storage locations, Ensuring the integrity and collision resistance of the hash function is critical for preventing unintended overwriting or access to storage areas
- The precompiled contract has potential takes too long to execute, exceeding the block's execution time frame limit.

---
#### Historical links related to this standard

- [EVM Storage Layout](https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html)
- Article from Avalanche [Customizing the EVM with Stateful Precompiles](https://medium.com/avalancheavax/customizing-the-evm-with-stateful-precompiles-f44a34f39efd)
- Article from AppLayer [Stateful Precompiles: EVM Game Changers or Another Overhyped Complexity?](https://medium.com/@AppLayerLabs/stateful-precompiles-evm-game-changers-or-another-overhyped-complexity-b064145b290e)
- Article from knauss [Precompiles & stateful precompiles](https://knauss.dev/posts/sixteenth-post/)
- Example Implementation `Native ERC20` contract from [moonbeam/moonriver](https://docs.moonbeam.network/builders/ethereum/precompiles/ux/erc20/)

#### Appendix

## License
Release under the [MIT] license.   
Copyright (C) to author. All rights reserved.