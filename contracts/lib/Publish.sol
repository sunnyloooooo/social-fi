// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {SpiderStruct} from "./Struct.sol";
import {Errors} from "./Errors.sol";
import {Events} from "./Events.sol";
import {Config} from "./Config.sol";

/**
 * @title Publish
 * @author Sunny
 *
 * @notice This is the library that contains the logic for profile creation & publication.
 *
 */
library Publish {
    /**
     * @notice Create a user profile with the provided data.
     * This function creates a user profile by associating the provided data, such as the handle or username, and the profile image URI, with the specified address.
     *
     * @param createProfileData The data required to create the user profile, including the address to associate the profile with, the chosen handle, and the profile image URI.
     * @param profileId The ID of the profile to be created.
     * @param _profileIdByHandleHash The mapping storing the profile ID by the handle hash.
     * @param _profileById The mapping storing the profile data by the profile ID.
     */
    function createProfile(
        SpiderStruct.CreateProfileData calldata createProfileData,
        uint256 profileId,
        mapping(bytes32 => uint256) storage _profileIdByHandleHash,
        mapping(uint256 => SpiderStruct.ProfileStruct) storage _profileById
    ) external {
        _validateHandle(createProfileData.handle);
        if (
            bytes(createProfileData.imageURI).length >
            Config.MAX_PROFILE_IMAGE_URI_LENGTH
        ) revert Errors.ProfileImageURILengthInvalid();
        bytes32 handleHash = keccak256(bytes(createProfileData.handle));
        if (_profileIdByHandleHash[handleHash] != 0)
            revert Errors.HandleTaken();
        _profileIdByHandleHash[handleHash] = profileId;
        _profileById[profileId].handle = createProfileData.handle;
        _profileById[profileId].imageURI = createProfileData.imageURI;
        _emitProfileCreated(profileId, createProfileData);
    }

    /**
     * @notice Creates a post on a user profile with the provided parameters.
     *
     * @dev To avoid a stack too deep error, reference parameters are passed in memory rather than calldata.
     *
     * @param profileId The ID of the profile where the post will be created.
     * @param contentURI The URI pointing to the content associated with the post.
     * @param pubId The ID to associate with the created post.
     * @param _pubByIdByProfile The storage reference to the mapping of publication structs by profile and post IDs.
     */
    function createPost(
        uint256 profileId,
        string memory contentURI,
        uint256 pubId,
        mapping(uint256 => mapping(uint256 => SpiderStruct.PublicationStruct))
            storage _pubByIdByProfile
    ) external {
        _pubByIdByProfile[profileId][pubId].contentURI = contentURI;

        emit Events.PostCreated(profileId, pubId, contentURI, block.timestamp);
    }

    /**
     * @notice Creates a comment on a publication with the provided parameters.
     *
     * @param commentData The CommentData struct containing the following parameters:
     *      profileId: The ID of the profile adding the comment.
     *      contentURI: The URI pointing to the content associated with the comment.
     * @param pubId The ID of the publication to add the comment to.
     * @param _pubByIdByProfile The storage reference to the mapping of publication structs by profile and publication IDs.
     */
    function createComment(
        SpiderStruct.CommentData memory commentData,
        uint256 pubId,
        mapping(uint256 => mapping(uint256 => SpiderStruct.PublicationStruct))
            storage _pubByIdByProfile
    ) external {
        _pubByIdByProfile[commentData.profileId][pubId].contentURI = commentData
            .contentURI;

        // Prevents a stack too deep error
        _emitCommentCreated(commentData, pubId);
    }

    function _emitProfileCreated(
        uint256 profileId,
        SpiderStruct.CreateProfileData calldata createProfileData
    ) private {
        emit Events.ProfileCreated(
            profileId,
            msg.sender,
            createProfileData.to,
            createProfileData.handle,
            createProfileData.imageURI,
            block.timestamp
        );
    }

    function _emitCommentCreated(
        SpiderStruct.CommentData memory commentData,
        uint256 pubId
    ) private {
        emit Events.CommentCreated(
            commentData.profileId,
            pubId,
            commentData.contentURI,
            block.timestamp
        );
    }

    function _validateHandle(string calldata handle) private pure {
        bytes memory byteHandle = bytes(handle);
        if (
            byteHandle.length == 0 ||
            byteHandle.length > Config.MAX_HANDLE_LENGTH
        ) revert Errors.HandleLengthInvalid();

        uint256 byteHandleLength = byteHandle.length;
        for (uint256 i = 0; i < byteHandleLength; ) {
            if (
                (byteHandle[i] < "0" ||
                    byteHandle[i] > "z" ||
                    (byteHandle[i] > "9" && byteHandle[i] < "a")) &&
                byteHandle[i] != "." &&
                byteHandle[i] != "-" &&
                byteHandle[i] != "_"
            ) revert Errors.HandleContainsInvalidCharacters();
            unchecked {
                ++i;
            }
        }
    }
}
