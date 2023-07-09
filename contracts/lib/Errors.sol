// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library Errors {
    /// @notice Error for creator not whitelisted
    error ProfileCreatorNotWhitelisted();

    /// @notice Error for handle length invalid
    error ProfileImageURILengthInvalid();

    /// @notice Error for handle taken
    error HandleTaken();

    /// @notice Error for handle length invalid
    error HandleLengthInvalid();

    /// @notice Error for handle contains invalid characters
    error HandleContainsInvalidCharacters();

    /// @notice Error for not profile owner
    error NotProfileOwner();

    /// @notice Error for publication does not exist
    error PublicationDoesNotExist();

    /// @notice Error for cannot comment on self
    error CannotCommentOnSelf();

    /// @notice Error for invalid 0 address
    error InvalidZeroAddr();
}

/**
 * @title Governance Custom Error library
 * @author Sunny
 * @notice Custom Error for Governance contract
 */
library GovernanceError {

}
