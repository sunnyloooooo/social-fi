// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Open Zeppelin libraries for controlling upgradability and access.
import "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

import {ISpider} from "./interfaces/ISpider.sol";
import {ISpiderNFT} from "./interfaces/ISpiderNFT.sol";
import {IGovernance} from "./interfaces/IGovernance.sol";
import {SpiderStorage} from "./lib/Storage.sol";
import {SpiderStruct} from "./lib/Struct.sol";
import {Config} from "./lib/Config.sol";
import {Errors} from "./lib/Errors.sol";
import {Checker} from "./lib/Checker.sol";
import {Address} from "./lib/Address.sol";
import {Publish} from "./lib/Publish.sol";

/**
 * @title Spider contract
 * @author Sunny
 */
contract Spider is
    Initializable,
    UUPSUpgradeable,
    AccessControlUpgradeable,
    ReentrancyGuardUpgradeable,
    ISpider
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    /// @dev Disable the initializer to prevent the implementation contract from being initialized
    constructor() {
        _disableInitializers();
    }

    /* ============ External Functions ============ */

    /// @notice spider contract initialization.
    /// @param data Encoded representation of initialization parameters
    function initialize(bytes calldata data) external initializer {
        __UUPSUpgradeable_init();
        __AccessControl_init();
        __ReentrancyGuard_init();
        (address adminAddr, address governanceAddr, address spiderNFTAddr) = abi
            .decode(data, (address, address, address));
        Checker.noneZeroAddr(adminAddr);
        Checker.noneZeroAddr(governanceAddr);
        Checker.noneZeroAddr(spiderNFTAddr);

        // set roles
        _setupRole(DEFAULT_ADMIN_ROLE, adminAddr);

        SpiderStorage.getStorage().governanceAddr = governanceAddr;
        SpiderStorage.getStorage().spiderNFTAddr = spiderNFTAddr;
    }

    /* ========== PROFILE OWNER FUNCTIONS ========== */

    function createProfile(
        SpiderStruct.CreateProfileData calldata createProfileData
    ) external returns (uint256) {
        if (
            !IGovernance(SpiderStorage.getStorage().governanceAddr)
                .isProfileCreatorWhitelisted(msg.sender)
        ) revert Errors.ProfileCreatorNotWhitelisted();
        unchecked {
            uint256 profileId = ++SpiderStorage.getStorage().profileCounter;
            ISpiderNFT(Address.getSpiderNFTAddr()).mint(
                createProfileData.to,
                profileId
            );
            Publish.createProfile(
                createProfileData,
                profileId,
                SpiderStorage.getStorage().profileIdByHandleHash,
                SpiderStorage.getStorage().profileById
            );
            return profileId;
        }
    }

    function post(
        SpiderStruct.PostData calldata postData
    ) external returns (uint256) {
        Checker.validateCallerIsProfileOwner(postData.profileId);
        unchecked {
            uint256 pubId = ++SpiderStorage
                .getStorage()
                .profileById[postData.profileId]
                .pubCount;
            Publish.createPost(
                postData.profileId,
                postData.contentURI,
                pubId,
                SpiderStorage.getStorage().pubByIdByProfile
            );
            return pubId;
        }
    }

    function comment(
        SpiderStruct.CommentData calldata commentData
    ) external override returns (uint256) {
        unchecked {
            uint256 pubId = ++SpiderStorage
                .getStorage()
                .profileById[commentData.profileId]
                .pubCount;
            Publish.createComment(
                commentData,
                pubId,
                SpiderStorage.getStorage().pubByIdByProfile
            );
            return pubId;
        }
    }

    /* ========== GETTER FUNCTIONS ========== */

    function getPubCount(
        uint256 profileId
    ) external view override returns (uint256) {
        return SpiderStorage.getStorage().profileById[profileId].pubCount;
    }

    function getContentURI(
        uint256 profileId,
        uint256 pubId
    ) external view override returns (string memory) {
        return
            SpiderStorage
            .getStorage()
            .pubByIdByProfile[profileId][pubId].contentURI;
    }

    function getProfileIdByHandle(
        string calldata handle
    ) external view override returns (uint256) {
        bytes32 handleHash = keccak256(bytes(handle));
        return SpiderStorage.getStorage().profileIdByHandleHash[handleHash];
    }

    function getProfile(
        uint256 profileId
    ) external view override returns (SpiderStruct.ProfileStruct memory) {
        return SpiderStorage.getStorage().profileById[profileId];
    }

    function getPub(
        uint256 profileId,
        uint256 pubId
    ) external view override returns (SpiderStruct.PublicationStruct memory) {
        return SpiderStorage.getStorage().pubByIdByProfile[profileId][pubId];
    }

    /* ========== Receive ========== */

    /// @notice Receive Ether from WETH contract
    receive() external payable {}

    /* ========== UUPS OVERRIDE ========== */

    /// @notice Override the _authorizeUpgrade function inherited from UUPSUpgradeable contract
    function _authorizeUpgrade(
        address
    ) internal view override onlyRole(DEFAULT_ADMIN_ROLE) {}
}
