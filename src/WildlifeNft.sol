// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract WildlifeNft is ERC721 {
    error WildlifeNft__CantFlipThroneIfNotOwner();

    string private s_lionSvgImageUri;
    string private s_tigerSvgImageUri;
    uint256 private s_tokenCounter;

    enum King {
        LION,
        TIGER
    }

    mapping(uint256 => King) private s_tokenIdToKing;

    constructor(string memory lionSvgImageUri, string memory tigerSvgImageUri) ERC721("WildLife NFT", "WDLF") {
        s_lionSvgImageUri = lionSvgImageUri;
        s_tigerSvgImageUri = tigerSvgImageUri;
        s_tokenCounter = 0;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToKing[s_tokenCounter] = King.LION;
        s_tokenCounter++;
    }

    function flipThrone(uint256 tokenId) public {
        if (!_isAuthorized(ownerOf(tokenId), msg.sender, tokenId)) {
            revert WildlifeNft__CantFlipThroneIfNotOwner();
        }

        if (s_tokenIdToKing[tokenId] == King.LION) {
            s_tokenIdToKing[tokenId] = King.TIGER;
        } else {
            s_tokenIdToKing[tokenId] = King.LION;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;

        if (s_tokenIdToKing[tokenId] == King.LION) {
            imageURI = s_lionSvgImageUri;
        } else {
            imageURI = s_tigerSvgImageUri;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "An NFT that shows King of the Jungle!", "attributes": [{"trait_type": "wildlife", "value": 100}], "image": "',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    function getTokenIdToKing(uint256 tokenId) public view returns (King) {
        return s_tokenIdToKing[tokenId];
    }
}
