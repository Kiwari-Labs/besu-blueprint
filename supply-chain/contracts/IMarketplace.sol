// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.0 <0.9.0;

/**
 * @title Interface of Marketplace
 */

interface IMarketplace {

    // not final yet.
    struct Order {
        address seller;
        address buyer; // if buyer of the order is equal to address(0) mean order still available.
        // mandatory
        uint256 price;
        uint64 createTimestamp;
        uint64 latestUpdateTimestamp;
    }

    // retrieve order detail
    function getOrderId(string memory id) external view returns (Order memory);

    // check is order exist in booking.
    function oderExist(string memory id) external view returns (bool);

    // place order to booking order.
    function sell(Order memory order) external;

    // but order from booking order.
    function buy(string memory id) external;

    // editing order detail.
    function editOrder(Order memory order) external;
}