// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "ds-test/test.sol";
import "../contracts/UUPSProxy.sol";
import {SpiderNFT} from "../contracts/SpiderNFT.sol";

contract ImplementationV1Test is DSTest {
    SpiderNFT implV1;
    UUPSProxy proxy;

    function setUp() public {
        // deploy logic contract
        implV1 = new SpiderNFT();
        // deploy proxy contract and point it to implementation
        proxy = new UUPSProxy(address(implV1), "");
        // initialize implementation contract
        address(proxy).call(
            abi.encodeWithSignature(
                "initialize(string,string)",
                "Spider NFT",
                "SPIDER"
            )
        );
    }

    function testInitialize() public {
        (bool success, bytes memory returnedData) = address(proxy).call(
            abi.encodeWithSignature("owner()")
        );
        address owner = abi.decode(returnedData, (address));
        assertTrue(success);
        // owner should be this contract
        assertEq(owner, address(this));
    }
}

contract SpiderNFTV2 is SpiderNFT {
    function testUpgrade() public returns (bool) {
        return true;
    }
}

contract ImplementationV2Test is DSTest {
    SpiderNFT implV1;
    SpiderNFTV2 implV2;
    UUPSProxy proxy;

    function setUp() public {
        // old logic contract
        implV1 = new SpiderNFT();
        // deploy proxy contract and point it to implementation
        proxy = new UUPSProxy(address(implV1), "");
        // initialize implementation contract
        address(proxy).call(
            abi.encodeWithSignature(
                "initialize(string,string)",
                "Spider NFT",
                "SPIDER"
            )
        );
        // deploy new logic contract
        implV2 = new SpiderNFTV2();
        // update proxy to new implementation contract
        (bool a, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("upgradeTo(address)", address(implV2))
        );
    }

    function testUpgrade() public {
        // proxy points to implV2, but name set via impl should still be valid, since storage from proxy contract is read
        (bool s, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("name()")
        );
        string memory name = abi.decode(data, (string));
        assertEq(name, "Spider NFT");

        (bool a, bytes memory returnedData) = address(proxy).call(
            abi.encodeWithSignature("testUpgrade()")
        );
        bool testReturn = abi.decode(returnedData, (bool));
        assertTrue(testReturn);
    }
}
