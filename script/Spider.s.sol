// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {Spider} from "../contracts/Spider.sol";
import {Governance} from "../contracts/Governance.sol";
import {SpiderNFT} from "../contracts/SpiderNFT.sol";
import {UUPSProxy} from "../contracts/UUPSProxy.sol";

contract SpiderDeployScript is Script {
    function deploy() public {
        Governance governance = new Governance();
        SpiderNFT spiderNFT = new SpiderNFT();
        Spider spider = new Spider();
        UUPSProxy governanceProxy = new UUPSProxy(address(governance), "");
        UUPSProxy spiderNFTProxy = new UUPSProxy(address(spiderNFT), "");
        UUPSProxy spiderProxy = new UUPSProxy(address(spider), "");

        address(governanceProxy).call(
            abi.encodeWithSignature(
                "initialize(bytes)",
                abi.encode(address(this), address(this))
            )
        );

        address(spiderNFTProxy).call(
            abi.encodeWithSignature(
                "initialize(string,string)",
                "Spider NFT",
                "SPIDER"
            )
        );
        address(spiderProxy).call(
            abi.encodeWithSignature(
                "initialize(bytes)",
                abi.encode(address(this), address(governance), address(this))
            )
        );
    }

    function run() external {
        vm.startBroadcast();
        // vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        deploy();
        vm.stopBroadcast();
    }
}
