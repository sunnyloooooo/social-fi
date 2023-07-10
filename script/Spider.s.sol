// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {Spider} from "../contracts/Spider.sol";
import {Governance} from "../contracts/Governance.sol";
import {SpiderNFT} from "../contracts/SpiderNFT.sol";
import {UUPSProxy} from "../contracts/UUPSProxy.sol";

contract SpiderDeployScript is Script {
    Governance governance;
    SpiderNFT spiderNFT;
    Spider spider;
    UUPSProxy governanceProxy;
    UUPSProxy spiderNFTProxy;
    UUPSProxy spiderProxy;

    function deploy() public {
        governance = new Governance();
        spiderNFT = new SpiderNFT();
        spider = new Spider();
        governanceProxy = new UUPSProxy(address(governance), "");
        spiderNFTProxy = new UUPSProxy(address(spiderNFT), "");
        spiderProxy = new UUPSProxy(address(spider), "");

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
                abi.encode(
                    address(this),
                    address(governanceProxy),
                    address(spiderNFTProxy)
                )
            )
        );
    }

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        deploy();
        vm.stopBroadcast();
    }
}
