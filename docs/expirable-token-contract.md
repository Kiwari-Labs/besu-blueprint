---
title: ERC20-Expirable A Fungible Token Standard with Expiration Feature
description: An extension of the ERC20 standard that enables the creation of fungible tokens with configurable expiration features, allowing for time-sensitive use cases.
author: sirawt (@MASDXI), ADISAKBOONMARK (@ADISAKBOONMARK)
status: Final
---

## Simple Summary

A standard interface enables ERC20 tokens to possess expiration capabilities, allowing them to expire after a predetermined period of time.

## Abstract

This standard introduces an extension for `ERC20` tokens, which facilitates the implementation of an expiration mechanism. Through this extension, tokens are designated a predetermined validity period, after which they become invalid and can no longer be transferred or used. This functionality proves beneficial in scenarios such as time-limited bond, loyalty reward , or game token necessitating automatic invalidation after a specific duration. The extension is meticulously crafted to seamlessly align with the existing `ERC20` standard, ensuring smooth integration with prevailing token contracts, while concurrently introducing the capability to govern and enforce token expiration at the contract level.

## Motivation

> Why limit yourself to tangible assets when tokenization empowers you to formalize the intangible? Transform loyalty points, credit scores, and time into secure digital assets that hold genuine value, redefining ownership and unlocking limitless opportunities.

This extension standard facilitates the development of `ERC20` standard compatible tokens featuring expiration dates. This capability broadens the scope of potential applications, particularly those involving time-sensitive assets. Expirable tokens are well-suited for scenarios necessitating temporary validity, including:

- Bonds or financial instruments with defined maturity dates
- Time-constrained assets within gaming ecosystems
- Next-gen loyalty programs incorporating expiring rewards or points
- Prepaid credits for utilities or services (e.g., cashback, data packages, fuel, computing resources) that expire if not used within a specified timeframe
- Postpaid telecom data package allocations that expire at the end of the billing cycle, motivating users to utilize their data before it resets
- Tokenized e-Money for a closed-loop ecosystem, such as transportation, food court, and retail payments

## Rationale

The rationale for developing an expirable `ERC20` token extension is based on several key requirements that ensure its practicality and adaptability for various applications to

- Compatibility with the existing `ERC20` standard. The extension should integrate smoothly with the `ERC20` interface, This ensures compatibility with existing token ecosystems and third-party tools like wallets and blockchain explorers.
- Flexible design for business use cases. The smart contract should be extensible, allowing businesses to tailor the expiration functionality to their specific needs, whether it’s dynamic reward systems or time-sensitive applications.
- Configurable expiration period. After deployment, users should have the flexibility to define and modify the expiration period of tokens according to their business requirements, supporting various use cases.
- Configurable block time after network upgrades. Following a blockchain network upgrade, block times may fluctuate upward or downward. The smart contract must support configurable block times to allow dynamic adjustments to the block times, ensuring expiration calculations remain accurate as transaction speeds evolve.
- Automatic selection of nearly expired tokens, When transferring tokens, the system should prioritize tokens that are approaching their expiration date, following a First-In-First-Out (`FIFO`) approach. This mechanism encourages users to utilize their tokens before they expire. Datat structure that suitable is `List` and `Queue`.
- Effortless on state management, The contract’s design minimizes the need for operation `WRITE` or `UPDATE` frequent on-chain state maintenance. By reducing reliance on off-chain indexing or caching, the system optimizes infrastructure usage and ensures streamlined performance without unnecessary dependencies. This design reduces operational overhead while keeping state securely maintained within the chain.
- Resilient Architecture, The contract architecture is built for robustness, supporting `EVM` types `1`, `2`, and `2.5`, and remains fully operational on Layer 2 solutions with sub-second block times. By anchoring operations to `block.number`, the system ensures asset integrity and continuity, even during prolonged network outages, safeguarding against potential asset loss. see more detail in [taiko article on EVM Types](https://taiko.mirror.xyz/j6KgY8zbGTlTnHRFGW6ZLVPuT0IV0_KmgowgStpA0K4)

## Design and Technique

#### Sliding Window Algorithm for maintain window to look for expiration balance

This contract creates an abstract implementation that adopts the **Sliding Window Algorithm** to maintain a window over a period of time (block height). This efficient approach allows for the look back and calculation of **usable balances** for each account within that window period. With this approach, the contract does not require a variable acting as a "counter" to keep updating the latest state (current period), nor does it need any interaction calls to keep updating the current period, which is an effortful and costly design.

#### Era and Slot for storing data in vertical and horizontal way

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
The `_worldBlockBalance` mapping tracks the total token balance across all accounts that minted tokens within a particular block. This structure allows the contract to trace expired balances easily. By consolidating balance data for each block.

#### Buffering 1 slot rule for ensuring safety

In this design, the buffering slot is the critical element that requires careful calculation to ensure accurate handling of balances nearing expiration. By incorporating this buffer, the contract guarantees that any expiring balance is correctly accounted for within the sliding window mechanism, ensuring reliability and preventing premature expiration or missed balances.

#### First-In-First-Out (FIFO) priority to enforce token expiration rules

Enforcing `FIFO` priority ensures that tokens nearing expiration are processed before newer ones, aligning with the token lifecycle and expiration rules. This method eliminates the need for additional off-chain computation and ensures that all token processing occurs efficiently on-chain, fully compliant with the ERC20 interface.
A **sorted** list is integral to this approach. Each slot maintains its own list, sorted by token creation which is can be `block.timestamp` or `blocknumber`, preventing any overlap with other slots. This separation ensures that tokens in one slot do not interfere with the balance handling in another. The contract can then independently manage token expirations within each slot, minimizing computation while maintaining accuracy and predictability in processing balances.

## Interfaces

```solidity
function tokenList(address account,uint256 era,uint8 slot) external view returns (uint256[] memory list);
```

- Purpose: This function retrieves a list of token associated with a specific account, within a given era and slot.
- Parameters:
  account: The address of the account whose token balances are being queried.
  - `era`: Refers to a specific time period or epoch in which the tokens are held.
  - `slot`: A subdivision of the era, representing finer divisions of time or state.
- Returns: An array list of token corresponding to the specified era and slot.  

```solidity
function balanceOfBlock(uint256 blocknumber) returns (uint256);
```

- Purpose: This function returns the balance of tokens at a specific blockchain blocknumber.
- Parameters:
  - `blocknumber`: The block number for which the token balance is being queried.
- Returns: The token balance as of that particular block number. This is useful for checking historical balances.

```solidity
function transfer(address to, uint256 fromEra, uint8 fromSlot, uint256 toEra, uint8 toSlot) external returns (bool);
```

- Purpose: This function works similarly to `ERC20` transfer but allows to move tokens within specific eras and slots.
- Parameters:
  - `to`: The address of the account to which tokens are being transferred.
  - `fromEra`: The era from which the tokens are being transferred.
  - `fromSlot`: The slot from which the tokens are being transferred.
  - `toEra`: The destination era to which the tokens will be transferred.
  - `toSlot`: The destination slot to which the tokens will be transferred.
- Returns: A boolean value indicating whether the transfer was successful.

```solidity
function transferFrom(address form, address to, uint256 fromEra,uint8 fromSlot,uint256 toEra,uint8 toSlot) external returns (bool);
```

- Purpose: This function works similarly to `ERC20` transferFrom but allows to move tokens within specific eras and slots.
- Parameters:
  - `from`: The address of the account from which tokens are being transferred.
  - `to`: The address of the account to which tokens are being transferred.
  - `fromEra`: The era from which the tokens are being transferred.
  - `fromSlot`: The slot from which the tokens are being transferred.
  - `toEra`: The destination era to which the tokens will be transferred.
  - `toSlot`: The destination slot to which the tokens will be transferred.
- Returns: A boolean value indicating whether the transfer was successful.

---

## Token Receipt and Transaction Likelihood across various blocktime

Assuming each `Era` contains 4 `slots`, which aligns with familiar time-based divisions like a year being divided into four quarters, the following table presents various scenarios based on block time and token receipt intervals. It illustrates the potential transaction frequency and likelihood of receiving tokens within a given period.

| Block Time (ms) | Receive Token Every (ms) | Index/Slot | Transactions per Day | Likelihood    |
| --------------- | ------------------------ | ---------- | -------------------- | ------------- |
| 100             | 100                      | 78,892,315 | 864,000              | Very Unlikely |
| 500             | 500                      | 15,778,463 | 172,800              | Very Unlikely |
| 1000            | 1000                     | 7,889,231  | 86,400               | Very Unlikely |
| 1000            | 28,800,000               | 273        | 3                    | Unlikely      |
| 1000            | 86,400,000               | 91         | 1                    | Possible      |
| 5000            | 86,400,000               | 18         | 1                    | Very Likely   |
| 10000           | 86,400,000               | 9          | 1                    | Very Likely   |

> Note:
>
> - Transactions per day are assumed based on loyalty point earnings.
> - Likelihood varies depending on the use case; for instance, gaming use cases may have higher transaction volumes than the given estimates.

## Security Considerations

- [SC06:Denial Of Service](https://owasp.org/www-project-smart-contract-top-10/2023/en/src/SC06-denial-of-service-attacks.html) Run out of gas problem due to the operation consuming high gas used if transferring multiple groups of small tokens [dust](https://www.investopedia.com/terms/b/bitcoin-dust.asp) transaction. the existing software or tool that `hardcode` the `gasLimit` should be considered to change.
- [SC09:Gas Limit Vulnerabilities](https://owasp.org/www-project-smart-contract-top-10/2023/en/src/SC09-gas-limit-vulnerabilities.html) Exceeds block gas limit if the blockchain have block gas limit lower than the gas used of the transaction.
- [SWC116:Block values as a proxy for time](https://swcregistry.io/docs/SWC-116/) and [avoid using `block.number` as a timestamp](https://consensys.github.io/smart-contract-best-practices/development-recommendations/solidity-specific/timestamp-dependence/#avoid-using-blocknumber-as-a-timestamp) Emphasize that network block times can fluctuate. In networks with variable block times, contracts relying on block values for time-based operations may not behave as expected. This can lead to inaccurate calculations or unintended outcomes.
- [Solidity Division Rounding Down](https://docs.soliditylang.org/en/latest/types.html#division) This contract may encounter scenarios where the calculated expiration block is shorter than the actual expiration block. This discrepancy can arise from the outputs of `blockPerYear` and `blockPerSlot * slotPerEra`, which may differ. Additionally, Solidity's division operation only returns integers, rounding down to the nearest whole number. However, by enforcing valid block times within the defined limits of `MINIMUM_BLOCK_TIME_IN_MILLISECONDS` and `MAXIMUM_BLOCK_TIME_IN_MILLISECONDS`, the contract mitigates this risk effectively.
- [State bloating](https://blog.codex.storage/bloated-blockchains-a-trilemma-data-availability-and-the-codex-answer/) The accumulation of tokens and associated data can lead to state bloat, significantly increasing the database size and affecting overall performance.

## Mitigating Performance Bottlenecks and Security Concern

- Implementing a function to change or adjust blocktime to match with certain blocktime of the network.
- Implementing a stateful precompiled contract to efficiently manage complex data structures, such as a circular doubly linked list, can significantly enhance performance on large dataset and reduce gas consumption.
- Adopting `blake2b` or `blake3` for calculating storage slots in stateful precompiled contracts, as opposed to using `keccak256`, can improve efficiency and speed.  
  related link
  - polkadot academy cryptography [hashes](https://polkadot-blockchain-academy.github.io/pba-book/cryptography/hashes/page.html)
  - crypto stack exchange question [#31674](https://crypto.stackexchange.com/questions/31674/what-advantages-does-keccak-sha-3-have-over-blake2)
- Increasing `blockGasLimit` to reducing the likelihood of transaction failures due to gas constraints.
- Optimizing the blockchain client configuration can significantly enhance throughput, aiming for gigagas per second (`Ggas/s`) processing capabilities.

---

#### Historical links related to this standard

- Implementation of [erc20-utxo](https://sirawt.medium.com/erc20exp-da3904e912b2)
- Implementation of [erc20-demurrage-token](https://github.com/nolash/erc20-demurrage-token)
- ethereum stack exchange question [#27379](https://ethereum.stackexchange.com/questions/27379/is-it-possible-to-create-an-expiring-ephemeral-erc-20-token)
- ethereum stack exchange question [#63937](https://ethereum.stackexchange.com/questions/63937/erc20-token-with-expiration-date)

#### Appendix

**Demurrage Token** definition often expressed as a decay in token balance  
**UTXO** definition Unspent Transaction Output.  
**e-Money** definition electronic money.  
**Era** definition is a Similar idea for a page in pagination.  
**FIFO** definition First-In-First-Out.  
**Slot** definition is Similar to the idea of the index on each page of pagination.  

## License

Release under the [BUSL-1.1](../LICENSE-BUSL) license.  
Copyright (C) to author. All rights reserved.
