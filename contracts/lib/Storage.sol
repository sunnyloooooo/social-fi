// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity ^0.8.19;
import {SpiderStruct} from "./Struct.sol";

/**
 * @title SpiderStorage library
 * @author Sunny
 * @notice Storage of the spider contract
 */
library SpiderStorage {
    /// @dev STORAGE_SLOT = bytes32(uint256(keccak256("spider.storage")) - 1)
    bytes32 private constant STORAGE_SLOT =
        0xeeb0ef4b7d2cb78c5032149e0922bd4bbb1f0843be1b97873a53c7522f6f443e;

    struct Storage {
        /// @notice Governance contract
        address governanceAddr;
        /// @notice SpiderNFT contract
        address spiderNFTAddr;
        /// @notice profile counter
        uint256 profileCounter;
        /// @notice profile handle hash => profile id
        mapping(bytes32 => uint256) profileIdByHandleHash;
        /// @notice profile id => profile data
        mapping(uint256 => SpiderStruct.ProfileStruct) profileById;
        /// @notice profile id => profile creator
        mapping(address => bool) profileCreatorWhitelisted;
        /// @notice profile id => publication id => publication data
        mapping(uint256 => mapping(uint256 => SpiderStruct.PublicationStruct)) pubByIdByProfile;
    }

    /// @dev Get the storage bucket for this contract.
    function getStorage() internal pure returns (Storage storage stor) {
        assert(
            STORAGE_SLOT == bytes32(uint256(keccak256("spider.storage")) - 1)
        );
        bytes32 slot = STORAGE_SLOT;

        // Dip into assembly to change the slot pointed to by the local
        // variable `stor`.
        // See https://solidity.readthedocs.io/en/v0.6.8/assembly.html?highlight=slot#access-to-external-variables-functions-and-libraries
        assembly {
            stor.slot := slot
        }
    }
}

library GovernanceStorage {
    /// @dev STORAGE_SLOT = bytes32(uint256(keccak256("governance.storage")) - 1)
    bytes32 private constant STORAGE_SLOT =
        0x1c03ec2fe6acf7b94b95c87bd1c750db913cc1fec10e1e766e5eb2c5f8b774f7;

    struct Storage {
        /// @notice Address of governor which will governance over the network i.e. add tokens
        address governorAddr;
        mapping(address => bool) profileCreatorWhitelisted;
    }

    /// @dev Get the storage bucket for this contract.
    function getStorage() internal pure returns (Storage storage stor) {
        assert(
            STORAGE_SLOT ==
                bytes32(uint256(keccak256("governance.storage")) - 1)
        );
        bytes32 slot = STORAGE_SLOT;

        // Dip into assembly to change the slot pointed to by the local
        // variable `stor`.
        // See https://solidity.readthedocs.io/en/v0.6.8/assembly.html?highlight=slot#access-to-external-variables-functions-and-libraries
        assembly {
            stor.slot := slot
        }
    }
}
