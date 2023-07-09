// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {GovernanceStruct} from "../lib/Struct.sol";

/**
 * @title Governance interface
 * @author Sunny
 * @notice Interface for governance contract
 */
interface IGovernance {
    /**
     * @notice Adds or removes a profile creator from the whitelist. This function can only be called by the current
     * governance address.
     *
     * @param profileCreator The profile creator address to add or remove from the whitelist.
     * @param whitelist Whether or not the profile creator should be whitelisted.
     */
    function whitelistProfileCreator(
        address profileCreator,
        bool whitelist
    ) external;

    function isProfileCreatorWhitelisted(
        address profileCreator
    ) external view returns (bool);
}
