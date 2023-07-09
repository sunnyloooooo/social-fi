// SPDX-License-Identifier: MIT
// solhint-disable-next-line
pragma solidity ^0.8.19;

import {SpiderStruct} from "../lib/Struct.sol";

/**
 * @title Spider interface
 * @author Sunny
 * @notice Interface for Spider contract
 */
interface ISpider {
    /* ========== PROFILE OWNER FUNCTIONS ========== */

    function createProfile(
        SpiderStruct.CreateProfileData calldata createProfileData
    ) external returns (uint256);

    function post(
        SpiderStruct.PostData calldata postData
    ) external returns (uint256);

    function comment(
        SpiderStruct.CommentData calldata commentData
    ) external returns (uint256);

    /* ========== GETTER FUNCTIONS ========== */

    function getPubCount(uint256 profileId) external view returns (uint256);

    function getContentURI(
        uint256 profileId,
        uint256 pubId
    ) external view returns (string memory);

    function getProfileIdByHandle(
        string calldata handle
    ) external view returns (uint256);

    function getProfile(
        uint256 profileId
    ) external view returns (SpiderStruct.ProfileStruct memory);

    function getPub(
        uint256 profileId,
        uint256 pubId
    ) external view returns (SpiderStruct.PublicationStruct memory);

    /// @notice Receive Ether from WETH contract
    receive() external payable;
}
