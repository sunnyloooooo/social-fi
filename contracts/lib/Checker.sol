// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity ^0.8.19;

import {Errors} from "./Errors.sol";
import {Address} from "./Address.sol";
import {ISpiderNFT} from "../interfaces/ISpiderNFT.sol";

/**
 * @title Checker library for Spider
 * @author Sunny
 * @notice The library for checking the validity of the input
 */
library Checker {
    /// @notice Check whether the address is 0 address
    /// @param addr The address to be checked
    function noneZeroAddr(address addr) internal pure {
        if (addr == address(0)) revert Errors.InvalidZeroAddr();
    }

    function validateCallerIsProfileOwner(uint256 profileId) internal view {
        if (
            msg.sender ==
            ISpiderNFT(Address.getSpiderNFTAddr()).ownerOf(profileId)
        ) {
            return;
        }
        revert Errors.NotProfileOwner();
    }
}
