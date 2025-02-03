// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.0 <0.9.0;

/**
 * @title Interface for Agriculture Tracking.
 */

interface IAgricultureTracking {
    enum STATE {
        DEFAULT, // 0 - Initial state (not yet recorded)
        PLANTED, // 1 - Crops are planted
        GROWING, // 2 - Crops are growing and monitored
        HARVESTED, // 3 - Crops have been harvested
        STORED, // 4 - Harvested goods stored in warehouse/silos
        TRANSPORTING, // 5 - Goods in transit
        PROCESSING, // 6 - Raw goods being processed into final product
        PACKAGED, // 7 - Goods packaged and labeled
        DISTRIBUTED, // 8 - Products moved to wholesalers/retailers
        SOLD, // 9 - Product sold to consumers
        EXPIRED, // 10 - Expired due to shelf-life / stored-life limitations
        RECALLED // 11 - Recalled due to contamination or defect
        // other your desirable ...
    }

    struct State {
        STATE state;
        uint64 timestamp;
    }

    event StateUpdated(uint256 indexed id, STATE state, uint256 timestamp);

    function updateState(bytes32 id, STATE state) external;

    function getCurrentState(bytes32 id) external view returns (State memory);

    function getHistory(bytes32 id) external view returns (State[] memory);
}
