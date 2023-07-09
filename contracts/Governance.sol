// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Open Zeppelin libraries for controlling upgradability and access.
import "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/access/AccessControlUpgradeable.sol";

import {IGovernance} from "./interfaces/IGovernance.sol";
import {GovernanceStorage} from "./lib/Storage.sol";
import {GovernanceEvents} from "./lib/Events.sol";
import {Config} from "./lib/Config.sol";
import {Checker} from "./lib/Checker.sol";
import {Errors} from "./lib/Errors.sol";

/**
 * @title Governance Contract
 * @author Sunny
 * @notice The Governance contract is a contract that manages the governance of the protocol.
 */
contract Governance is
    Initializable,
    UUPSUpgradeable,
    AccessControlUpgradeable,
    IGovernance
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    /// @dev Disable the initializer to prevent the implementation contract from being initialized
    constructor() {
        _disableInitializers();
    }

    /* ========== External Functions ========== */

    /// @notice Governance contract initialization.
    /// @param data Encoded representation of initialization parameters:
    function initialize(bytes calldata data) external initializer {
        __UUPSUpgradeable_init();
        __AccessControl_init();
        (address adminAddr, address operatorAddr) = abi.decode(
            data,
            (address, address)
        );
        Checker.noneZeroAddr(adminAddr);
        Checker.noneZeroAddr(operatorAddr);

        // set roles
        _setupRole(DEFAULT_ADMIN_ROLE, adminAddr);
        _grantRole(Config.OPERATOR_ROLE, operatorAddr);
    }

    function whitelistProfileCreator(
        address profileCreator,
        bool isWhitelist
    ) external override onlyRole(Config.OPERATOR_ROLE) {
        GovernanceStorage.getStorage().profileCreatorWhitelisted[
            profileCreator
        ] = isWhitelist;
        emit GovernanceEvents.ProfileCreatorWhitelisted(
            profileCreator,
            isWhitelist,
            block.timestamp
        );
    }

    function isProfileCreatorWhitelisted(
        address profileCreator
    ) external view override returns (bool) {
        return
            GovernanceStorage.getStorage().profileCreatorWhitelisted[
                profileCreator
            ];
    }

    /* ========== Internal Functions ========== */

    /// @notice Override the _authorizeUpgrade function inherited from UUPSUpgradeable contract
    function _authorizeUpgrade(
        address
    ) internal view override onlyRole(DEFAULT_ADMIN_ROLE) {}
}
