// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployerBasicNft;
    BasicNft public nft;
    address public alice;

    function setUp() public {
        deployerBasicNft = new DeployBasicNft();
        nft = deployerBasicNft.run();

        alice = makeAddr("alice");
    }

    function testNftNameSymbolAreCorrect() public {
        string memory name = "Royal Bengal Tiger";
        string memory symbol = "RBT";

        assert(keccak256(abi.encodePacked(nft.name())) == keccak256(abi.encodePacked(name)));
        assertEq(nft.name(), name);
        assertEq(nft.symbol(), symbol);
    }

    function testCounterInitializesToZero() public {
        assertEq(nft.getTokenCounter(), 0);
    }

    function testMintNftWorksUpdatesCounterAndOwnerMapping() public {
        // mint nft
        vm.prank(alice);
        string memory tokenUri = "royalbengaltiger.xyz/1";
        nft.mintNFT(tokenUri);

        // Assert
        assertEq(nft.tokenURI(0), tokenUri);
        assert(keccak256(abi.encodePacked(nft.tokenURI(0))) == keccak256(abi.encodePacked(tokenUri)));
        assertEq(nft.ownerOf(0), alice);
        assertEq(nft.balanceOf(alice), 1);
        assertEq(nft.getTokenCounter(), 1);

        // get tokenUri for tokenId
        // get user as owner of token
        // get user balance
        // token counter updates
    }
}
