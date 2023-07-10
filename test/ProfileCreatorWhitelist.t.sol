// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/Governance.sol";
import {UUPSProxy} from "../contracts/UUPSProxy.sol";

contract ProfileCreatorWhitelistTest is Test {
    address public operator;
    address public user;
    UUPSProxy governanceProxy;
    Governance governance;

    function setUp() public {
        user = makeAddr("User");
        operator = makeAddr("operator");

        governance = new Governance();
        governanceProxy = new UUPSProxy(address(governance), "");

        address(governanceProxy).call(
            abi.encodeWithSignature(
                "initialize(bytes)",
                abi.encode(address(this), operator)
            )
        );
    }

    function test_ProfileCreatorWhitelist() public {
        vm.startPrank(operator);

        (bool success, ) = address(governanceProxy).call(
            abi.encodeWithSignature(
                "whitelistProfileCreator(address,bool)",
                user,
                true
            )
        );
        assertEq(success, true);

        (bool s, bytes memory data) = address(governanceProxy).call(
            abi.encodeWithSignature(
                "isProfileCreatorWhitelisted(address)",
                user
            )
        );
        assertEq(s, true);
        bool isWhitelisted = abi.decode(data, (bool));
        assertEq(isWhitelisted, true);

        vm.stopPrank();
    }

    function test_NotOperator_ProfileCreatorWhitelist_Fail() public {
        vm.startPrank(user);

        (bool success, ) = address(governanceProxy).call(
            abi.encodeWithSignature(
                "whitelistProfileCreator(address,bool)",
                user,
                true
            )
        );
        assertEq(success, false);
        vm.stopPrank();
    }
}
