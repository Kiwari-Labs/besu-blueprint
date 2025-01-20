// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.0 <0.9.0;

/**
 * @title Interface of Product
 */

interface IProduct {

    // not final yet.
    struct Product {
        string name;
        string uri;
        uint256 vendorId;
        // mandatory
        uint64 createTimestamp;
        uint64 latestUpdateTimestamp;
    }

    function getProduct(string memory id) external view returns (Product memory);

    function productExist(string memory id) external view returns (bool);

    function addProduct(Product memory product) external;

    function removeProduct(string memory id) external;

    function editProduct(Product memory product) external; 
}