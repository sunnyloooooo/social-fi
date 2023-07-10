// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../contracts/Governance.sol";
import "../../contracts/lib/Struct.sol";
import "../../contracts/lib/Config.sol";
import {Errors} from "../../contracts/lib/Errors.sol";
import {UUPSProxy} from "../../contracts/UUPSProxy.sol";
import {SpiderDeployScript} from "../../script/Spider.s.sol";

contract ProfileCreationTest is Test, SpiderDeployScript {
    address public user;
    address public user2;

    function setUp() public {
        user = makeAddr("User");
        user2 = makeAddr("User2");
        super.deploy();
        (bool success, ) = address(governanceProxy).call(
            abi.encodeWithSignature(
                "whitelistProfileCreator(address,bool)",
                user,
                true
            )
        );

        assertEq(success, true);
    }

    function test_createProfile_fail_with_handle_longer_than_31_btyes() public {
        vm.startPrank(user);
        string memory val = "12345678901234567890123456789012";
        SpiderStruct.CreateProfileData memory createProfileData = SpiderStruct
            .CreateProfileData(user, val, "ipfs://xxx");
        (bool revertsAsExpected, ) = address(spiderProxy).call(
            abi.encodeWithSignature(
                "createProfile((address,string,string))",
                createProfileData
            )
        );
        assertFalse(revertsAsExpected, "expectRevert: handle length invalid");
        vm.stopPrank();
    }

    function test_createProfile_fail_with_handle_empty() public {
        vm.startPrank(user);
        string memory val = "";
        SpiderStruct.CreateProfileData memory createProfileData = SpiderStruct
            .CreateProfileData(user, val, "ipfs://xxx");
        (bool revertsAsExpected, ) = address(spiderProxy).call(
            abi.encodeWithSignature(
                "createProfile((address,string,string))",
                createProfileData
            )
        );
        assertFalse(revertsAsExpected, "expectRevert: handle empty");
        vm.stopPrank();
    }

    function test_createProfile_fail_with_handle_contain_capital_letter()
        public
    {
        vm.startPrank(user);
        string memory val = "CapitalHandle";
        SpiderStruct.CreateProfileData memory createProfileData = SpiderStruct
            .CreateProfileData(user, val, "ipfs://xxx");
        (bool revertsAsExpected, ) = address(spiderProxy).call(
            abi.encodeWithSignature(
                "createProfile((address,string,string))",
                createProfileData
            )
        );
        assertFalse(
            revertsAsExpected,
            "expectRevert: handle contain capital letter"
        );
        vm.stopPrank();
    }

    function test_createProfile_fail_with_handle_contain_invalid_letter()
        public
    {
        vm.startPrank(user);
        string memory val = "hi!";
        SpiderStruct.CreateProfileData memory createProfileData = SpiderStruct
            .CreateProfileData(user, val, "ipfs://xxx");
        (bool revertsAsExpected, ) = address(spiderProxy).call(
            abi.encodeWithSignature(
                "createProfile((address,string,string))",
                createProfileData
            )
        );
        assertFalse(
            revertsAsExpected,
            "expectRevert: handle contain invalid letter"
        );
        vm.stopPrank();
    }

    function test_createProfile_fail_with_imageUri_invalid_length() public {
        vm.startPrank(user);
        string memory invalidImageUri = "h";
        while (
            bytes(invalidImageUri).length <
            Config.MAX_PROFILE_IMAGE_URI_LENGTH + 1
        ) {
            invalidImageUri = string(abi.encodePacked(invalidImageUri, "h"));
        }
        SpiderStruct.CreateProfileData memory createProfileData = SpiderStruct
            .CreateProfileData(user, "user", invalidImageUri);
        (bool revertsAsExpected, ) = address(spiderProxy).call(
            abi.encodeWithSignature(
                "createProfile((address,string,string))",
                createProfileData
            )
        );
        assertFalse(
            revertsAsExpected,
            "expectRevert: image uri length invalid"
        );
        vm.stopPrank();
    }

    function test_createProfile_fail_with_not_whitelisted_profile_creator()
        public
    {
        vm.startPrank(user2);
        string memory val = "i_am_not_whitelisted";
        SpiderStruct.CreateProfileData memory createProfileData = SpiderStruct
            .CreateProfileData(user, val, "ipfs://xxx");
        (bool revertsAsExpected, ) = address(spiderProxy).call(
            abi.encodeWithSignature(
                "createProfile((address,string,string))",
                createProfileData
            )
        );
        assertFalse(
            revertsAsExpected,
            "expectRevert: profile creator not whitelisted"
        );
        vm.stopPrank();
    }

    function test_createProfile_with_expected_id() public {
        vm.startPrank(user);
        string memory val = "user";
        SpiderStruct.CreateProfileData memory createProfileData = SpiderStruct
            .CreateProfileData(user, val, "ipfs://xxx");
        (bool success, bytes memory data) = address(spiderProxy).call(
            abi.encodeWithSignature(
                "createProfile((address,string,string))",
                createProfileData
            )
        );
        assertTrue(success);
        uint256 profileId = abi.decode(data, (uint256));
        assertEq(profileId, 1);
        vm.stopPrank();
    }

    function test_createProfile_with_expected_nft() public {
        vm.startPrank(user);
        string memory val = "user";
        SpiderStruct.CreateProfileData memory createProfileData = SpiderStruct
            .CreateProfileData(user, val, "ipfs://xxx");
        (bool success, bytes memory data) = address(spiderProxy).call(
            abi.encodeWithSignature(
                "createProfile((address,string,string))",
                createProfileData
            )
        );
        assertTrue(success);
        uint256 profileId = abi.decode(data, (uint256));
        assertEq(profileId, 1);
        (bool s, bytes memory d) = address(spiderNFTProxy).call(
            abi.encodeWithSignature("ownerOf(uint256)", profileId)
        );
        assertTrue(s);
        address ownerOf = abi.decode(d, (address));
        assertEq(ownerOf, user);
        vm.stopPrank();
    }

    function test_createProfile_with_handle_contain_specific_characters()
        public
    {
        vm.startPrank(user);
        string memory val = "user_one-handle.";
        SpiderStruct.CreateProfileData memory createProfileData = SpiderStruct
            .CreateProfileData(user, val, "ipfs://xxx");
        (bool success, ) = address(spiderProxy).call(
            abi.encodeWithSignature(
                "createProfile((address,string,string))",
                createProfileData
            )
        );
        assertTrue(success);
        vm.stopPrank();
    }

    function test_createProfile_with_handle_16_btyes_and_fail_with_same_handle()
        public
    {
        vm.startPrank(user);
        string memory val = "1234567890123456";
        SpiderStruct.CreateProfileData memory createProfileData = SpiderStruct
            .CreateProfileData(user, val, "ipfs://xxx");
        (bool success, ) = address(spiderProxy).call(
            abi.encodeWithSignature(
                "createProfile((address,string,string))",
                createProfileData
            )
        );
        assertTrue(success);
        (bool revertsAsExpected, ) = address(spiderProxy).call(
            abi.encodeWithSignature(
                "createProfile((address,string,string))",
                createProfileData
            )
        );
        assertFalse(revertsAsExpected, "expectRevert: handle has been taken");
        vm.stopPrank();
    }

    function test_createProfile_for_user_two() public {
        vm.startPrank(user);
        string memory val = "1234567890123456";
        SpiderStruct.CreateProfileData memory createProfileData = SpiderStruct
            .CreateProfileData(user2, val, "ipfs://xxx");
        (bool success, ) = address(spiderProxy).call(
            abi.encodeWithSignature(
                "createProfile((address,string,string))",
                createProfileData
            )
        );
        assertTrue(success);
        vm.stopPrank();
    }
}
