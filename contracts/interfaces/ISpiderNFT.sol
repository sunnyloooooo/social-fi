// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC721Upgradeable} from "openzeppelin-contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";

/**
 * @title ISpiderNFT
 * @author Sunny
 *
 * @notice This is the interface for the SpiderNFT contract.
 */
interface ISpiderNFT is IERC721Upgradeable {
    function mint(address to, uint256 tokenId) external;
}
