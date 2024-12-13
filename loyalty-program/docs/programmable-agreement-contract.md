---
title: Programmable Agreement Contract
description: A smart contract standard to facilitate agreements between multiple parties
author: sirawt (@MASDXI)
status: Draft
---

## Simple Summary

The Programmable Agreement Contract lets multiple parties create, update, and finalize legally binding agreements on the blockchain, using smart contracts for automatic enforcement and transparency of the agreed terms.

## Abstract

This standard establishes on-chain agreement contracts to create and manage agreements in a decentralized environment. It empowers parties to formalize agreements using self-executing smart contracts without intermediaries. The contract unequivocally supports proposing, approving, or rejecting agreements and meticulously records transactions associated with each party’s consent or dissent. It is meticulously designed to seamlessly integrate with decentralized systems while introducing robust mechanisms for agreement management.

## Motivation

The aim is to create a digital contract system that borrows principles from traditional legal agreements and integrates them with blockchain technology. By drawing inspiration from

- [Bilateral Agreement](https://www.law.cornell.edu/wex/bilateral_contract) two-party agreements in which each party fulfills their obligations.
- [Multilateral Agreement](https://www.law.cornell.edu/wex/multilateral) multiple parties agreements which each party fulfills their obligations.
- [Smart legal Contract](https://lawcom.gov.uk/project/smart-contracts) automated and enforceable agreements that operate on decentralized networks without the need for intermediaries.

## Rationale

- Proxy Pattern smart contract for modularity and flexible for business logic
- Multi-signature mechanism to ensure that all parties involved in the agreement provide their consent, enhancing security and trustworthiness.
- High level Syntax that simplifies the development process, making it easier for users to create and manage agreements without deep knowledge of Solidity or blockchain programming.

## Design and Technique

#### Wrapped comparison operation into high level syntax

This concept refers to abstracting common comparison operations (like comparing amounts, addresses, or balances) into reusable functions or methods that simplify complex logic.  
By wrapping these comparisons into higher-level constructs, the contract becomes more modular and easier to read, maintain, while serving secure and extendable.

```solidity
    /// @notice Checks if two addresses are equal
    /// @param x The first address to compare
    /// @param y The second address to compare
    /// @return result True if the addresses are equal, otherwise false
    function equal(address x, address y) internal pure returns (bool result) {
        assembly {
            result := eq(x, y)
        }
    }
```

```solidity
    /// ... skipping
    using AddressComparator for address;

    function compare(address x, address y) public view return (bool) {
        return x.equal(y);
    }
```

#### Implementation Contract Template

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/// @title Customized Agreement
/// @author <author@domain.com>

import "@kiwarilabs/contracts/abstracts/AgreementTemplate.sol";

contract CustomizedAgreement is AgreementTemplate {
    function _verifyAgreement(
        bytes memory x,
        bytes memory y
    ) internal override returns (bool) {
        // #################### start your custom logic ####################
        // ... desirable logic here
        // #################### end your custom logic ####################
        // do not change the line below.
        return true;
    }
}
```

From above template contract, `CustomizedAgreement`, shows how you can create custom logic within an agreement by inheriting from the `AgreementTemplate` and overriding the `_verifyAgreement` function.  
This setup provides flexibility to implement any specific logic while keeping the rest of the structure intact.

#### Example Implementation Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/// @title General Token Amount Agreement
/// @notice This contract serves as a template for creating bilateral agreements based on token amounts.
/// It facilitates programmable agreements between two parties involving the exchange or validation of token amounts.
/// @author Kiwari Labs

import "@kiwarilabs/contracts/libraries/utils/AddresComparator.sol";
import "@kiwarilabs/contracts/libraries/utils/IntComparator.sol";
import "@kiwarilabs/contracts/abstracts/AgreementTemplate.sol";

contract GeneralTokenAgreement is AgreementTemplate {
    using IntComparator for uint256;
    using AddressCompartor for address;

    function _verifyAmountToken(
        uint inputTokenAmount,
        uint requiredAmount
    ) private pure returns (bool) {
        return inputTokenAmount.equal(requiredAmount);
    }

    function _verifyBalanceToken(
        address token,
        address bilateralAgreementContract,
        uint requiredAmountToken
    ) private pure returns (bool) {
        return
            (IERC20(token).balanceOf(bilateralAgreementContract)).equal(
                requiredAmountToken
            );
    }

    function _verifyBilateralContract(
        address contractA,
        address contractB
    ) private pure returns (bool) {
        return contractA.equal(contractB);
    }

    function _verifyAgreement(
        bytes memory x,
        bytes memory y
    ) internal override returns (bool) {
        // #################### start your custom logic ####################
        // Decode amounts and addresses from both parties
        (
            uint amountTokenA,
            uint requiredAmountTokenB,
            address tokenA,
            address agreementContractA
        ) = abi.decode(x, (uint, uint, address, address));
        (
            uint amountTokenB,
            uint requiredAmountTokenA,
            address tokenB,
            address agreementContractB
        ) = abi.decode(y, (uint, uint, address, address));
        // Verify contract addresses, token amounts, and balances
        require(
            _verifyBilateralContract(agreementContractA, agreementContractB),
            "Invalid agreement contract"
        );
        require(
            _verifyAmountToken(amountTokenA, requiredAmountTokenA) &&
                _verifyAmountToken(amountTokenB, requiredAmountTokenB),
            "Invalid token amounts"
        );
        require(
            _verifyBalanceToken(amountTokenA, agreementContractA) &&
                _verifyBalanceToken(amountTokenB, agreementContractB),
            "Invalid token balances"
        );
        // #################### end your custom logic ####################
        // do not change the line below.
        return true;
    }
}
```

This example shows how to create a specific type of agreement - one that compares token amounts and verifies balances between two parties using smart contract addresses.

#### Using bytes data type for flexible and struct free

using `bytes` instead of `struct`, the Programmable Agreement Contract achieves greater flexibility, lower gas costs cause efficient data are packed from off-chain, and easier upgradeability.  
The bytes data type enables the contract to handle dynamic and arbitrary data, making it adaptable to a wide range of use cases without requiring predefined, rigid data structures like `struct`.

## Interface

#### Interface of Agreement Contract

```solidity
event ImplementationUpdated(address indexed oldImplementation, address indexed newImplementation);
```

- Propose: Emitted when the implementation of the contract is updated.
- Parameters:
  - `oldImplementation`: The previous contract implementation.
  - `newImplementation`: The new contract implementation.

```solidity
event TransactionFinalized(uint256 indexed index);
```

- Propose: Emitted when a transaction is completed.
- Parameters:
  - `index`: The index of the transaction that was finalized.

```solidity
event TransactionRecorded(uint256 indexed index,address indexed sender,TRANSACTION_TYPE indexed transactionType,bytes data);
```

- Propose: Emitted when a new transaction is recorded.
- Parameters:
  - `index`: The index of the recorded transaction.
  - `sender`: The address of the sender initiating the transaction.
  - `transactionType`: The type of the transaction.
  - `data`: The data associated with the transaction.
- Enum: `TRANSACTION_TYPE`
- `DEFAULT`: Represents a standard transaction, such as an agreement.
- `LOGIC_CHANGE`: Represents a transaction that involves a change in the contract's logic or functionality.

```solidity
event TransactionRejected(uint256 indexed index, address indexed sender);
```

- Propose: Emitted when a transaction is rejected.
- Parameters:
  - `index`: The index of the rejected transaction.
  - `sender`: The address of the sender whose transaction was rejected.

```solidity
event TransactionRevoked(uint256 indexed index, address indexed sender);
```

- Propose: Emitted when a transaction is revoked.
- Parameters:
  - `index`: The index of the revoked transaction.
  - `sender`: The address of the sender who revoked the transaction.

---

```solidity
function transactionLength() external view returns (uint256);
```

- Propose: Returns the number of transactions stored in the contract.
- Returns: The total number of transactions in the contract.

```solidity
function status() external view returns (bool);
```

- Propose: Checks the execution status of the latest transaction.
- Returns: `true` if the current transaction has been executed; otherwise, `false`.

```solidity
function approveAgreement(bytes calldata data) external;
```

- Propose: Submits a transaction to approve an agreement.
- Parameters:
  - `data`: The encoded data required for the transaction approval.

```solidity
function approveChange(bytes calldata data) external;
```

- Propose: Submits a transaction to approve a logic change.
- Parameters:
  - `data`: The encoded data required for the transaction approval.

```solidity
function revokeTransaction() external;
```

- Propose: Revokes the most recent transaction submitted by the sender.

```solidity
function rejectTransaction() external;
```

- Propose: Rejects the most recent transaction submitted by the sender.

```solidity
function implementation() external view returns (address);
```

- Propose: Returns the address of the agreement contract.
- Returns: The address of the `_agreementContract`.

---

#### Interface of Implementation Contract

```solidity
function agreement(bytes memory x, bytes memory y) external returns (bool);
```

- Propose: Evaluates the bilateral agreement between party A and party B
- Parameters:
  - `x`: The input parameters provided by party A
  - `y`: The input parameters provided by party B
- Returns: True if the agreement is valid, otherwise false

```solidity
function name() external view returns (string memory);
```

- Propose: Returns the name of the agreement contract.
- Returns: The name of the agreement contract.

```solidity
function version() external view returns (uint256);
```

- Propose: Returns the current version of the agreement
- Returns: The version number of the agreement

## Security Considerations

- [SWC126:Insufficient Gas Griefing](https://swcregistry.io/docs/SWC-126/) the complexity of logic within functions like `_verifyAgreement` could lead to situations where gas limits are exceeded when external call to `agreement` function.
- [SWC123:Requirement Violation](https://swcregistry.io/docs/SWC-123/) due the high level syntax `require` declaration incorrect declarations may lead to requirement violations, potentially allowing the agreement to be exploited.
- [SWC131:Presence of unused variables](https://swcregistry.io/docs/SWC-131/) When working with the `bytes` data type, especially during decoding, some of the decoded data might remain unused. This could lead to the presence of unnecessary variables in the contract.

---

#### Historical links related to this standard

- Article from Hedera: [Smart Legal Contract](https://hedera.com/learning/smart-contracts/smart-legal-contracts)
- Project from Law Commission UK: [Smart Legal Contract](https://lawcom.gov.uk/project/smart-contracts)

#### Appendix

**ABI** definition Application Binary Interface  
**Multi-Signature** definition requirement for a transaction to have two or more signatures before it can be executed

## Copyright

Copyright and related rights waived via [CC0]().
