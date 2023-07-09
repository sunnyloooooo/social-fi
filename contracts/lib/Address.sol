// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity ^0.8.19;

import {SpiderStorage} from "./Storage.sol";

/**
 * @title Address library
 * @author Sunny
 * @notice Address library for Spider
 */
library Address {
    /// @notice Return the address of governance contract
    /// @return governanceAddr Address of governance contract
    function getGovernanceAddr()
        internal
        view
        returns (address governanceAddr)
    {
        return SpiderStorage.getStorage().governanceAddr;
    }

    /// @notice Return the address of SpiderNFT contract
    /// @return spiderNFTAddr Address of SpiderNFT contract
    function getSpiderNFTAddr() internal view returns (address spiderNFTAddr) {
        return SpiderStorage.getStorage().spiderNFTAddr;
    }
}
