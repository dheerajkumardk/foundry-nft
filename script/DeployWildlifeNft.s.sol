// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {WildlifeNft} from "../src/WildlifeNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployWildlifeNft is Script {
    function run() external returns (WildlifeNft) {
        string memory lionSvg = vm.readFile("./img/lion.svg");
        string memory tigerSvg = vm.readFile("./img/tiger.svg");

        vm.startBroadcast();
        WildlifeNft wildNft = new WildlifeNft(
            svgToImageURI(lionSvg),
            svgToImageURI(tigerSvg)
        );
        vm.stopBroadcast();
        return wildNft;
    }

    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}
