// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.0 <0.9.0;

/**
 * @title Interface of Supply Chain
 * Related Standard for Supply Chain
 * Supply Chain Operations Reference Digital Standard (SCOR DS) form Association for Supply Chain Management (ASCM)
 * Global Traceability Standard from GS1
 * ISO 9001:2015 from International Organization for Standardization (ISO)
 */

/// @notice this is only simple supply chain interface
interface ISupplyChain {

    enum STATE {
        NULL,
        CREATED,
        PACKAGING,
        PICKUP,
        TRANSIT,
        STORED,
        DELIVERY_FAILED,
        DELIVERY_SUCCESSFUL,
        RETURNING,
        CANCELED,
        EXCEPTION
    }

    struct Status {
        STATE[] states;
    }

    struct Product {
        // if on-blockchain
        string name;
        uint256 vendorId;
        // if off-blockchain
        string uri; // metadata store off-blockchain
        uint64 createTimestamp;
        uint64 latestUpdateTimestamp;
        Status status;
    }

    function getProduct(
        string memory id
    ) external view returns (Product memory);
    function productExist(string memory id) external view returns (bool);
    function addProduct(Product memory product) external;
    function removeProduct(string memory id) external;
    // @TODO avoid editing state of status if store metadata on-blockchain.
    function editProduct(Product memory product) external;
    function editProductState(string memory id, STATE state) external;
    function latestStateOfProduct(
        string memory id
    ) external view returns (STATE);
}
