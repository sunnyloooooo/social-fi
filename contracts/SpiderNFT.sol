// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/access/OwnableUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {IERC165Upgradeable, ERC721EnumerableUpgradeable} from "openzeppelin-contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";

import {ISpiderNFT} from "./interfaces/ISpiderNFT.sol";

/**
 * @title SpiderNFT
 * @author Sunny
 *
 * @notice This is an contract to be inherited by other Spider Protocol NFTs.
 */
contract SpiderNFT is
    Initializable,
    ERC721Upgradeable,
    ERC721EnumerableUpgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable,
    ISpiderNFT
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    /// @dev Disable the initializer to prevent the implementation contract from being initialized
    constructor() {
        _disableInitializers();
    }

    /* ============ External Functions ============ */

    /// @notice spider contract initialization.
    /// @param _name NFT name
    /// @param _symbol NFT symbol
    function initialize(
        string memory _name,
        string memory _symbol
    ) public initializer {
        __ERC721_init(_name, _symbol);
        __Ownable_init();
        __UUPSUpgradeable_init();
        __ERC721Enumerable_init();
    }

    function mint(address to, uint256 tokenId) external {
        _safeMint(to, tokenId);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://Qma2uFDzG1aWrHYrtpwiXdh7xqf7wpxdXJ6osJV6TyEydJ/";
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721Upgradeable, ERC721EnumerableUpgradeable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(
            ERC721Upgradeable,
            ERC721EnumerableUpgradeable,
            IERC165Upgradeable
        )
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /// @notice Override the _authorizeUpgrade function inherited from UUPSUpgradeable contract
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
