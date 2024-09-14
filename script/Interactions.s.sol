// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DevOpsTools} from 'foundry-devops/src/DevOpsTools.sol';

contract MintBasicNft is Script {
    string public constant TIGER = "royalbengaltiger.xyz/1";

    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);
        mintNft(mostRecentDeployment);
    }

    function mintNft(addess nftContract) public {
        vm.startBroadcast();
        BasicNft(nftContract).mintNFT(TIGER);
        vm.stopBroadcast();
    }
}