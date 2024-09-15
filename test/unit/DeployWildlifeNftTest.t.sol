// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployWildlifeNft} from "../../script/DeployWildlifeNft.s.sol";

contract DeployWildlifeNftTest is Test {
    DeployWildlifeNft public deployer;

    function setUp() public {
        deployer = new DeployWildlifeNft();
    }

    function testSvgToImage() public {
        string memory expectedURI =
            "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAwIiBoZWlnaHQ9IjEwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSI1MCIgY3k9IjUwIiByPSI0MCIgc3Ryb2tlPSJncmVlbiIgc3Ryb2tlLXdpZHRoPSI0IiBmaWxsPSJ5ZWxsb3ciIC8+U29ycnksIHlvdXIgYnJvd3NlciBkb2VzIG5vdCBzdXBwb3J0IGlubGluZSBTVkcuPC9zdmc+";

        string memory svg =
            '<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><circle cx="50" cy="50" r="40" stroke="green" stroke-width="4" fill="yellow" />Sorry, your browser does not support inline SVG.</svg>';

        string memory actualURI = deployer.svgToImageURI(svg);

        assert(keccak256(abi.encodePacked(expectedURI)) == keccak256(abi.encodePacked(actualURI)));

        console.log(actualURI);
    }
}
