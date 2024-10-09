---
title: Programmable Agreement Contract
description: A smart contract standard for create agreements between multiple parties.
author: sirawt (@MASDXI)
status: Draft
---

## Simple Summary

## Abstract

## Motivation

- [Bilateral Agreement](https://www.law.cornell.edu/wex/bilateral_contract)
- [Multilateral Agreement](https://www.law.cornell.edu/wex/multilateral)
- [Smart legal Contract](https://lawcom.gov.uk/project/smart-contracts)

## Rationale

- Modularity Flexible
- High level Syntax
- Multi-signature mechanism

## Design and Technique

#### Wrapped comparison operation into high level syntax

#### Using bytes data type for flexible and struct free

## Interface

``` solidity
function name() public returns (bool);
```

``` solidity
function version() public returns (bool);
```

``` solidity
function agreement() public returns (bool);
```

## Security Considerations

---
#### Historical links related to this standard

- [SWC126:Insufficient Gas Griefing](https://swcregistry.io/docs/SWC-126/)
- Article from Hedera: [Smart Legal Contract](https://hedera.com/learning/smart-contracts/smart-legal-contracts)
- Project from Law Commission United Kingdom: [Smart Legal Contract](https://lawcom.gov.uk/project/smart-contracts)

#### Appendix

## License
Release under the [MIT] license.   
Copyright (C) to author. All rights reserved.