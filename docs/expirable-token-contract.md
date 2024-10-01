---
title: ERC20-Expirable A Fungible Token Standard with Expiration Feature
description: An extension of the ERC20 standard that enables the creation of fungible tokens with configurable expiration features, allowing for time-sensitive use cases.
author: sirawt (@MASDXI), ADISAKBOONMARK (@ADISAKBOONMARK)
status: Draft
---

## Simple Summary

A standard interface enables ERC20 tokens to possess expiration capabilities, allowing them to expire after a predetermined period of time.

## Abstract

This standard introduces an extension for `ERC20` tokens, which facilitates the implementation of an expiration mechanism. Through this extension, tokens are designated a predetermined validity period, following which they become void and are no longer transferable or usable. This functionality proves beneficial in scenarios such as time-limited bond, loyalty reward , or game token necessitating automatic invalidation after a specific duration. The extension is meticulously crafted to seamlessly align with the existing `ERC20` standard, ensuring smooth integration with prevailing token contracts, while concurrently introducing the capability to govern and enforce token expiration at the contract level.

## Motivation

> Why settle for security-backed tokenization of old bricks and mortar when you can mint digital assets representing real-world intangibles?, Real estate may have a location, but data knows no boundaries.

This extension standard facilitates the development of `ERC20` standard compatible tokens featuring expiration dates. This capability broadens the scope of potential applications, particularly those involving time-sensitive assets. Expirable tokens are well-suited for scenarios necessitating temporary validity, including:

- Bonds or financial instruments with defined maturity dates
- Time-constrained assets within gaming ecosystems
- Next-gen loyalty programs incorporating expiring rewards or points
- Prepaid credits for utilities or services (e.g., cashback, data packages, fuel, computing resources) that expire if not used within a specified timeframe
- Postpaid telecom data package allocations that expire at the end of the billing cycle, motivating users to utilize their data before it resets
- Tokenized e-Money for a closed-loop ecosystem, such as transportation, food court, and retail payments

## Rationale

The rationale for developing an expirable `ERC20` token extension is based on several key requirements that ensure its practicality and adaptability for various applications

- Compatibility with the existing `ERC20` standard. The extension must seamlessly integrate with the established `ERC20` interface, ensuring easy adoption and interoperability within existing token ecosystems. This includes full compatibility with third-party tools, such as wallets and blockchain explorers.
- Flexible design for business use cases. The smart contract should be extensible, allowing businesses to tailor the expiration functionality to their specific needs, whether it’s dynamic reward systems or time-sensitive applications.
- Configurable expiration period. After deployment, users should have the flexibility to define and modify the expiration period of tokens according to their business requirements, supporting various use cases.
- Configurable block time after network upgrades. Following a blockchain network upgrade, block times may fluctuate upward or downward. The smart contract must support configurable block times to allow dynamic adjustments to the block times, ensuring expiration calculations remain accurate as transaction speeds evolve.
  Automatic selection of nearly expired tokens, When transferring tokens, the system should prioritize tokens that are approaching their expiration date, following a First-In-First-Out (`FIFO`) approach. This mechanism encourages users to utilize their tokens before they expire.
- Effortless on state management, The contract’s design minimizes the need for operation `WRITE` frequent on-chain state maintenance. By reducing reliance on off-chain indexing or caching, the system optimizes infrastructure usage and ensures streamlined performance without unnecessary dependencies. This design reduces operational overhead while keeping state securely maintained within the chain.
- Resilient Architecture:  The contract architecture is built for robustness, supporting `EVM` types `1`, `2`, and `2.5`, and remains fully operational on Layer 2 solutions with sub-second block times. By anchoring operations to `block.number`, the system ensures asset integrity and continuity, even during prolonged network outages, safeguarding against potential asset loss.

## Specification

#### Era and Slot Conceptual

This contract creates an abstract implementation that adopts the sliding window algorithm to maintain a window over a period of time (block height). This efficient approach allows for the look back and calculation of usable balances for each account within that window period. With this approach, the contract does not require a variable acting as a "counter" to keep updating the latest state (current period), nor does it need any interaction calls to keep updating the current period, which is an effortful and costly design.

#### Storing data in vertical and horizontal way

```solidity
    // ... skipping

    struct Slot {
        uint256 slotBalance;
        mapping(uint256 => uint256) blockBalances;
        CircularDoublyLinkedList.List list;
    }

    //... skipping

    mapping(address => mapping(uint256 => mapping(uint8 => Slot))) private _balances;
    mapping(uint256 => uint256) private _worldBlockBalance;
```

With this struct `Slot` it provides an abstract loop in a horizontal way more efficient for calculating the usable balance of the account because it provides `slotBalance` which acts as suffix balance so you don't need to get to iterate or traversal over the `list` for each `Slot` to calculate the entire slot balance if the slot can presume not to expire. otherwise struct `Slot` also provides vertical in a sorted list.

#### Ensure Safety with Buffer Slot

In the design sliding window algorithm needs to be coarse because it's deterministic and fixed in size to ensure that a usable balance that nearly expires will be included in the usable balance of the account it's needs to buffered one slot.

- [ ] This contract provides a loyalty reward like, it's expirable so it's not suitable to have `MAX_SUPPLY`.
- [ ] This contract has `gasUsed` per interaction higher than the original ERC20.
- [ ] This contract relies on `block.number` rather than `block.timestamp` so whatever happens that makes the network halt asset will be safe.
- [ ] This contract can have a scenario where the expiration block is shorter than the actual true expiration block, due to the `blockPerYear` and `blockPerSlot * slotPerEra` output from calculate can be different.

Assuming each era contains 4 slots.
| Block Time (ms) | Receive Token Every (ms) | index/slot | tx/day | Likelihood |
|-----------------|--------------------------|-------------------------|--------|--------------|
| 100 | 100 | 78,892,315 | 864,000| Very Unlikely|
| 500 | 500 | 15,778,463 | 172,800| Very Unlikely|
| 1000 | 1000 | 7,889,231 | 86,400 | Very Unlikely|
| 1000 | 28,800,000 | 273 | 3 | Unlikely |
| 1000 | 86,400,000 | 91 | 1 | Possible |
| 5000 | 86,400,000 | 18 | 1 | Very Likely |
| 10000 | 86,400,000 | 9 | 1 | Very Likely |

Note:

- Transactions per day are assumed based on loyalty point earnings.
- Likelihood varies depending on the use case; for instance, gaming use cases may have higher transaction volumes than the given estimates.

## Security Considerations

- [SC06:2023-Denial Of Service](https://owasp.org/www-project-smart-contract-top-10/2023/en/src/SC06-denial-of-service-attacks.html) Run out of gas problem due to the operation consuming high gas used if transferring multiple groups of small tokens [dust](https://www.investopedia.com/terms/b/bitcoin-dust.asp) transaction.
- [SC09:2023-Gas Limit Vulnerabilities](https://owasp.org/www-project-smart-contract-top-10/2023/en/src/SC09-gas-limit-vulnerabilities.html) Exceeds block gas limit if the blockchain have block gas limit lower than the gas used of the transaction.
- [SWC116:Block values as a proxy for time](https://swcregistry.io/docs/SWC-116/) and [avoid using `block.number` as a timestamp](https://consensys.github.io/smart-contract-best-practices/development-recommendations/solidity-specific/timestamp-dependence/#avoid-using-blocknumber-as-a-timestamp) Emphasize that network block times can fluctuate. In networks with variable block times, contracts relying on block values for time-based operations may not behave as expected. This can lead to inaccurate calculations or unintended outcomes.
- The accumulation of tokens and associated data can lead to state bloat, significantly increasing the database size and affecting overall performance.

## Mitigating Performance Bottlenecks and Security Concern

- Implementing a function to change or adjust blocktime to match with certain blocktime of the network.
- Implementing a stateful precompiled contract to efficiently manage complex data structures, such as a circular doubly linked list, can significantly enhance performance on large dataset and reduce gas consumption.
- Adopting `blake2b` or `blake3` for calculating storage slots in stateful precompiled contracts, as opposed to using `keccak256`, can improve efficiency and speed.
- Increasing `blockGasLimit` to reducing the likelihood of transaction failures due to gas constraints.
- Optimizing the blockchain client configuration can significantly enhance throughput, aiming for gigagas per second (`Ggas/s`) processing capabilities.

## History

Historical links related to this standard:

- Implementation of [erc20-utxo](https://sirawt.medium.com/erc20exp-da3904e912b2)
- Implementation of [erc20-demurrage-token](https://github.com/nolash/erc20-demurrage-token)
- ethereum stack exchange question [#27379](https://ethereum.stackexchange.com/questions/27379/is-it-possible-to-create-an-expiring-ephemeral-erc-20-token)
- ethereum stack exchange question [#63937](https://ethereum.stackexchange.com/questions/63937/erc20-token-with-expiration-date)

#### Appendix

`e-Money` definition electronic money.  
`Era` definition is a Similar idea for a page in pagination.
`FIFO` definition First-In-First-Out.  
`Slot` definition is Similar to the idea of the index on each page of pagination.  
\*\* The first index of the slot is 0
