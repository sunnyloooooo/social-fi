// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library Events {
    /**
     * @notice Event emitted when a user profile is successfully created.
     *
     * @param profileId The ID of the created profile (token ID).
     * @param creator The address of the creator who initiated the profile creation.
     * @param to The address to which the profile is associated.
     * @param handle The handle or username chosen for the profile.
     * @param imageURI The URI of the profile image.
     * @param timestamp The timestamp when the profile was created.
     */
    event ProfileCreated(
        uint256 indexed profileId,
        address indexed creator,
        address indexed to,
        string handle,
        string imageURI,
        uint256 timestamp
    );

    /**
     * @notice Event emitted when a post is successfully created on a user profile.
     *
     * @param profileId The ID of the profile where the post was created.
     * @param pubId The ID of the created post.
     * @param contentURI The URI of the content associated with the post.
     * @param timestamp The timestamp when the post was created.
     */
    event PostCreated(
        uint256 indexed profileId,
        uint256 indexed pubId,
        string contentURI,
        uint256 timestamp
    );

    /**
     * @notice Event emitted when a comment is successfully created on a publication.
     *
     * @param profileId The ID of the profile that added the comment.
     * @param pubId The ID of the publication where the comment was added.
     * @param contentURI The URI of the content associated with the comment.
     * @param timestamp The timestamp when the comment was created.
     */
    event CommentCreated(
        uint256 indexed profileId,
        uint256 indexed pubId,
        string contentURI,
        uint256 timestamp
    );
}

library GovernanceEvents {
    /**
     * @notice Event emitted when a profile creator is whitelisted or removed from the whitelist.
     *
     * @param profileCreator The address of the profile creator.
     * @param whitelisted A boolean indicating whether the profile creator is whitelisted (true) or removed from the whitelist (false).
     * @param timestamp The timestamp when the whitelist status was updated.
     */
    event ProfileCreatorWhitelisted(
        address indexed profileCreator,
        bool indexed whitelisted,
        uint256 timestamp
    );
}
