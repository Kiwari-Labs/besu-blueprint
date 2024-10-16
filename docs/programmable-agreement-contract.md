---
title: Programmable Agreement Contract
description: A smart contract standard to facilitate agreements between multiple parties
author: sirawt (@MASDXI)
status: Draft
---

## Simple Summary  
The Programmable Agreement Contract lets multiple parties create, update, and finalize legally binding agreements on the blockchain, using smart contracts for automatic enforcement and transparency of the agreed terms.

## Abstract  

## Motivation  

- [Bilateral Agreement](https://www.law.cornell.edu/wex/bilateral_contract)
- [Multilateral Agreement](https://www.law.cornell.edu/wex/multilateral)
- [Smart legal Contract](https://lawcom.gov.uk/project/smart-contracts)

## Rationale

- Proxy Pattern smart contract for modularity and flexible for business logic 
- Multi-signature mechanism to ensure that all parties involved in the agreement provide their consent, enhancing security and trustworthiness.
- High level Syntax that simplifies the development process, making it easier for users to create and manage agreements without deep knowledge of Solidity or blockchain programming.

## Design and Technique

#### Wrapped comparison operation into high level syntax

This concept refers to abstracting common comparison operations (like comparing amounts, addresses, or balances) into reusable functions or methods that simplify complex logic. By wrapping these comparisons into higher-level constructs, the contract becomes more modular and easier to read, maintain, while serving secure and extendable.

#### Implementation Contract Template
``` solidity
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
From above template contract, `CustomizedAgreement`, shows how you can create custom logic within an agreement by inheriting from the `AgreementTemplate` and overriding the `_verifyAgreement` function. This setup provides flexibility to implement any specific logic while keeping the rest of the structure intact.

#### Example Implementation Contract

``` solidity
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
using `bytes` instead of `struct`, the Programmable Agreement Contract achieves greater flexibility, lower gas costs cause efficient data are packed from off-chain, and easier upgradeability. The bytes data type enables the contract to handle dynamic and arbitrary data, making it adaptable to a wide range of use cases without requiring predefined, rigid data structures like `struct`.

## Interface

#### Interface of Agreement Contract

``` solidity
// event ImplementationUpdated(address indexed oldImplementation, address indexed newImplementation);
// event TransactionFinalized(uint256 indexed index);
// event TransactionRecorded(uint256 indexed index,address indexed sender,TRANSACTION_TYPE indexed transactionType,bytes data);
// event TransactionRejected(uint256 indexed index, address indexed sender);
// event TransactionRevoked(uint256 indexed index, address indexed sender);
```

``` solidity
function transactionLength() external view returns (uint256);
```
- Propose:  
- Returns:  

``` solidity
function status() external view returns (bool);
```
- Propose:  
- Returns:  

``` solidity
function approveAgreement(bytes calldata data) external;
```
- Propose:  
- Parameters:  

``` solidity
function approveChange(bytes calldata data) external;
```
- Propose:  
- Parameters:  
  
``` solidity
function revokeTransaction() external;
```
- Propose:  

``` solidity
function rejectTransaction() external;
```
- Propose:  
- Returns:  

``` solidity
function implementation() external view returns (address);
```
- Propose:  

#### Interface of Implementation Contract
``` solidity
function agreement(bytes memory x, bytes memory y) external returns (bool);
```
- Propose:  
- Parameters:  
- Returns:  

``` solidity
function name() external view returns (string memory);
```
- Propose:  
- Returns:  


``` solidity
function version() external view returns (uint256);
```
- Propose:  
- Returns:  

## Security Considerations

- [SWC126:Insufficient Gas Griefing](https://swcregistry.io/docs/SWC-126/) he complexity of logic within functions like `_verifyAgreement` could lead to situations where gas limits are exceeded when external call to `agreement` function.
- [SWC123:Requirement Violation](https://swcregistry.io/docs/SWC-123/) 
- [SWC131:Presence of unused variables](https://swcregistry.io/docs/SWC-131/) 

---
#### Historical links related to this standard

- Article from Hedera: [Smart Legal Contract](https://hedera.com/learning/smart-contracts/smart-legal-contracts)
- Project from Law Commission UK: [Smart Legal Contract](https://lawcom.gov.uk/project/smart-contracts)

#### Appendix

## License
Release under the [MIT] license.   
Copyright (C) to author. All rights reserved.