// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library Config {
    uint8 internal constant MAX_HANDLE_LENGTH = 31;
    uint16 internal constant MAX_PROFILE_IMAGE_URI_LENGTH = 6000;
    bytes32 internal constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
}
