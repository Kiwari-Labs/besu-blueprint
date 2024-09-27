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

This extension standard facilitates the development of `ERC20` standard compatible tokens featuring expiration dates. This capability broadens the scope of potential applications, particularly those involving time-sensitive assets. Expirable tokens are well-suited for scenarios necessitating temporary validity, including:

- Bonds or financial instruments with defined maturity dates
- Time-constrained assets within gaming ecosystems
- Next-generation loyalty programs incorporating expiring rewards or points

## Specification

## Rationale

The rationale for developing an expirable `ERC20` token extension is based on several key requirements that ensure its practicality and adaptability for various applications:

- Compatibility with Existing `ERC20` Standard: The extension must seamlessly integrate with the established `ERC20` interface, allowing for easy adoption and interoperability with existing token ecosystems.
- Configurable Expiration Period: Users should have the flexibility to define and modify the expiration period of tokens according to their business needs, enabling dynamic reward systems or time-sensitive applications.
- Configurable Block Period (Blocktime): The system should allow for adjustments to the block period, ensuring that expiration calculations remain relevant as network conditions and transaction speeds evolve.
- Automatic Selection of Nearly Expired Tokens (`FIFO`): When transferring tokens, the mechanism should prioritize the selection of tokens approaching their expiration date, following a First-In-First-Out (`FIFO`) approach. This ensures that users are incentivize to utilize their tokens before they expire.
- Extensible Design for Business Use Cases: The architecture should be extensible, enabling businesses to tailor the expiration functionality to their specific use cases.

##### Era and Slot Conceptual

This contract creates an abstract implementation that adopts the sliding window algorithm to maintain a window over a period of time (block height). This efficient approach allows for the look back and calculation of usable balances for each account within that window period. With this approach, the contract does not require a variable acting as a "counter" to keep updating the latest state (current period), nor does it need any interaction calls to keep updating the current period, which is an effortful and costly design.

ExpirePeriod to ERA-SLOT Mapping.
| SLOT | ERA cycle |
|------|-----------------------|
| 1 | 0 ERA cycle, 1 SLOT |
| 2 | 0 ERA cycle, 2 SLOT |
| 3 | 0 ERA cycle, 3 SLOT |
| 4 | 1 ERA cycle, 0 SLOT |
| 5 | 1 ERA cycle, 1 SLOT |
| 6 | 1 ERA cycle, 2 SLOT |
| 7 | 1 ERA cycle, 3 SLOT |
| 8 | 2 ERA cycle, 0 SLOT |
| 9 | 2 ERA cycle, 1 SLOT |
| 10 | 2 ERA cycle, 2 SLOT |
| 11 | 2 ERA cycle, 3 SLOT |
| 12 | 3 ERA cycle, 0 SLOT |
| 13 | 3 ERA cycle, 1 SLOT |
| 14 | 3 ERA cycle, 2 SLOT |
| 15 | 3 ERA cycle, 3 SLOT |
| 16 | 4 ERA cycle, 0 SLOT |

##### Vertical and Horizontal Scaling

```solidity
    struct Slot {
        uint256 slotBalance;
        mapping(uint256 => uint256) blockBalances;
        CircularDoublyLinkedList.List list;
    }

    //... skipping

    mapping(address => mapping(uint256 => mapping(uint8 => Slot))) private _balances;
```

With this struct `Slot` it provides an abstract loop in a horizontal way more efficient for calculating the usable balance of the account because it provides `slotBalance` which acts as suffix balance so you don't need to get to iterate or traversal over the `list` for each `Slot` to calculate the entire slot balance if the slot can presume not to expire. otherwise struct `Slot` also provides vertical in a sorted list.

##### Buffer Slot

In the design sliding window algorithm needs to be coarse because it's deterministic and fixed in size to ensure that a usable balance that nearly expires will be included in the usable balance of the account it's needs to buffered one slot.

- [ ] This contract provides a loyalty reward like, it's expirable so it's not suitable to have `MAX_SUPPLY`.
- [ ] This contract has `gasUsed` per interaction higher than the original ERC20.
- [ ] This contract relies on `block.number` rather than `block.timestamp` so whatever happens that makes the network halt asset will be safe.
- [ ] This contract can have a scenario where the expiration block is shorter than the actual true expiration block, due to the `blockPerYear` and `blockPerSlot * slotPerEra` output from calculate can be different.

```text
    /* @note Motivation
    * Avoid changing ERC20 Interface Standard, support most ERC20 Interface Standard as much as possible.
    * Avoid declaring ERA or SLOT as a global variable and maintain the counter style as much as possible.
    * support configurable expiration period change.
    * support configurable blocks produce per year of the network are change.
    * support extensible hook logic beforeTransfer, AfterTransfer if use @openzeppelin v4.x and above.
    * smart contract address can be granted as a wholesale account so tokens in the contract are non-expirable.
    * ** To ensure balance correctness it's need to buffer 1 slot for look back.
    * ** Warning: avoid to combine this contract with other ERC20 extension,
    *    due it's can cause unexpected behavior.
    * ** Warning: this relies on block.number more than the block.timestamp
    *    in some scenarios expiration blocks are shortened than the actual true expiration block
    *
    */
```

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

## Security Considerations

- [SC06:2023-Denial Of Service](https://owasp.org/www-project-smart-contract-top-10/2023/en/src/SC06-denial-of-service-attacks.html)Run out of gas problem due to the operation consuming high gas used if transferring multiple groups of small tokens [dust](https://www.investopedia.com/terms/b/bitcoin-dust.asp) transaction.
- [SC09:2023-Gas Limit Vulnerabilities](https://owasp.org/www-project-smart-contract-top-10/2023/en/src/SC09-gas-limit-vulnerabilities.html) Exceeds block gas limit if the blockchain have block gas limit lower than the gas used of the transaction.
- The accumulation of tokens and associated data can lead to state bloat, significantly increasing the database size and affecting overall performance.

## Mitigating Performance Bottlenecks

- Implementing a stateful precompiled contract to efficiently manage complex data structures, such as a circular doubly linked list, can significantly enhance performance on large dataset and reduce gas consumption.
- Adopting `blake2b` or `blake3` for calculating storage slots in stateful precompiled contracts, as opposed to using `keccak256`, can improve efficiency and speed.
- Increasing `blockGasLimit` to reducing the likelihood of transaction failures due to gas constraints.
- Optimizing the blockchain client configuration can significantly enhance throughput, aiming for gigagas per second (`Ggas/s`) processing capabilities.

## History

Historical links related to this standard:

#### Appendix

`Era` definition is a Similar idea for a page in pagination.

`FIFO` definition First In First Out.

`Slot` definition is Similar to the idea of the index on each page of pagination.  
\*\* The first index of the slot is 0
