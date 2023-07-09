// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Spider struct library
 * @author Sunny
 *
 * @notice A data struct used throughout the Spider Protocol.
 */
library SpiderStruct {
    /**
     * @notice Struct containing data required to create a user profile.
     *
     * @param to The address to which the profile will be created.
     * @param handle The handle or username chosen by the user, must be unique and non-empty.
     * @param imageURI The URI for the user's profile image.
     */
    struct CreateProfileData {
        address to;
        string handle;
        string imageURI;
    }

    /**
     * @notice Struct representing a user profile.
     *
     * @param pubCount The number of publications made by the profile.
     * @param handle The handle or username associated with the profile.
     * @param imageURI The URI of the profile image.
     */
    struct ProfileStruct {
        uint256 pubCount;
        string handle;
        string imageURI;
    }

    /**
     * @notice Struct representing data required to create a post on a user profile.
     *
     * @param profileId The ID of the profile where the post will be created.
     * @param contentURI The URI pointing to the content associated with the post.
     */
    struct PostData {
        uint256 profileId;
        string contentURI;
    }

    /**
     * @notice Struct representing a publication.
     *
     * @param contentURI The URI pointing to the content associated with the publication.
     */
    struct PublicationStruct {
        string contentURI;
    }

    /**
     * @notice Struct representing data required to add a comment to a publication.
     *
     * @param profileId The ID of the profile adding the comment.
     * @param contentURI The URI pointing to the content associated with the comment.
     */
    struct CommentData {
        uint256 profileId;
        string contentURI;
    }
}

/**
 * @title Governance struct library
 * @author Sunny
 * @notice Structs of Governance contract
 */
library GovernanceStruct {

}
