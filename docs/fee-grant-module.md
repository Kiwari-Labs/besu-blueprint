---
title: Fee Grant Module
description: A guide to implementing a stateful precompiled contract for fee grant to the user.
author:  Paramet Kongjaroen (@parametprame), sirawt (@MASDXI)
discussions-to: URL
type: Standard Track
category: Core
created: 27-06-2024
status: Draft
---

## Motivation

<!-- TODO -->

## Specification

The keywords “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “NOT RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in RFC 2119 and RFC 8174.

The `GasFeeGrant` module **MUST** implement following function below and **MUST** follow the function behavior

```solidity
// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.20;

interface IGasFeeGrant {
    enum ALLOWANCE_TYPE {
        NON_ALLOWANCE,
        BASIC_ALLOWANCE, 
        PERIODIC_ALLOWANCE,
        // APP_ALLOWANCE,
        // APP_PERIODIC_ALLOWANCE
    }

    function grantAllowance() external returns (bool);

    function revokeAllowance() external returns (bool);

    function allowance() external view returns ();

    function isAllowanceExpired(address account) external view returns (bool);

    function remainingAllowance(address account) external view returns (uint256);

    function spentAllowance(address account) external view returns (uint256);

    function granterOf(address account) external view returns (uin256);

    // function remainingAllowance(address account, address dapp) external view returns (uint256);
    
    // function isAllowanceExpired(address account, address dapp) external view returns (bool);

    // function spentAllowance(address account, address dapp) external view returns (uint256);

    // function granterOf(address account, address dapp) external view returns (address);
}
```

### Transaction Validation Behavior

<!-- TODO -->

### Transaction Processor Behavior

<!-- TODO -->

## Rationale

<!-- TODO -->

## Backwards Compatibility

> TODO

## Security Considerations


### Historical links related to this standard

- [kaia/fee-delegation](https://docs.kaia.io/build/tutorials/fee-delegation-example/)
- [cosmos-sdk/feegrant](https://docs.cosmos.network/main/build/modules/feegrant#abstract) used by
  - [sei](https://www.docs.sei.io/dev-advanced-concepts/fee-grants)
  - [xpla](https://docs.xpla.io/develop/develop/core-modules/fee-grant/)

## Copyright

Copyright and related rights waived via [CC0]().
