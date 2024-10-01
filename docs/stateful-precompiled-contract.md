---
title: Stateful Precompiled Contract
description: A stateful precompiled smart contract for executing complexity task.
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

## Specification

#### Determining the Stateful Precompiled Contract Address

This section explains how the address of the stateful precompiled contract, `CONTRACT_ADDRESS`, is calculated.

```
var contractAddress = keccak256("<CONTRACT_NAME>").toString().slice(0, 20)
```

1. Hash the Contract Name: The contract name is hashed using the keccak256 algorithm.
2. Extract the Address: The resulting hash is then converted to a string, and the first 20 characters are taken as the contract's address.  
   This method ensures a unique and consistent address for the stateful precompiled contract based on its name.

## Rationale

#### Appendix

## Security Considerations

- [SWC124:Write to Arbitrary Storage Location](https://swcregistry.io/docs/SWC-124/) Using an alternate hash function instead of keccak256 for storage slot calculations could potentially expose vulnerabilities, such as writing to arbitrary storage locations, Ensuring the integrity and collision resistance of the hash function is critical for preventing unintended overwriting or access to storage areas
-
