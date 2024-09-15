// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployWildlifeNft} from "../../script/DeployWildlifeNft.s.sol";
import {WildlifeNft} from "../../src/WildlifeNft.sol";

contract WildlifeNftIntegrationTest is Test {
    DeployWildlifeNft public deployWildNft;
    WildlifeNft public wildNft;
    address public alice;

    string public constant LION_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyMDAiIGhlaWdodD0iMjAwIj4KICA8IS0tIExpb24ncyBNYW5lIC0tPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgcj0iOTAiIGZpbGw9ImJyb3duIiBzdHJva2U9ImJsYWNrIiBzdHJva2Utd2lkdGg9IjMiLz4KICAKICA8IS0tIExpb24ncyBGYWNlIC0tPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgcj0iNzAiIGZpbGw9ImdvbGQiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIvPgogIAogIDwhLS0gTGlvbidzIEV5ZXMgLS0+CiAgPGNpcmNsZSBjeD0iNzAiIGN5PSI4MCIgcj0iMTAiIGZpbGw9IndoaXRlIi8+CiAgPGNpcmNsZSBjeD0iMTMwIiBjeT0iODAiIHI9IjEwIiBmaWxsPSJ3aGl0ZSIvPgogIAogIDwhLS0gTGlvbidzIFB1cGlscyAtLT4KICA8Y2lyY2xlIGN4PSI3MCIgY3k9IjgwIiByPSI1IiBmaWxsPSJibGFjayIvPgogIDxjaXJjbGUgY3g9IjEzMCIgY3k9IjgwIiByPSI1IiBmaWxsPSJibGFjayIvPgogIAogIDwhLS0gTGlvbidzIE5vc2UgLS0+CiAgPHBvbHlnb24gcG9pbnRzPSI5MCwxMTAgMTEwLDExMCAxMDAsMTMwIiBmaWxsPSJibGFjayIvPgogIAogIDwhLS0gTGlvbidzIE1vdXRoIC0tPgogIDxsaW5lIHgxPSI5MCIgeTE9IjE0MCIgeDI9IjExMCIgeTI9IjE0MCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIyIi8+CiAgCiAgPCEtLSBMaW9uJ3MgV2hpc2tlcnMgLS0+CiAgPGxpbmUgeDE9IjYwIiB5MT0iMTIwIiB4Mj0iOTAiIHkyPSIxMjAiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMiIvPgogIDxsaW5lIHgxPSIxMTAiIHkxPSIxMjAiIHgyPSIxNDAiIHkyPSIxMjAiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMiIvPgo8L3N2Zz4K";
    string public constant TIGER_SVG_IMAGE_URI =
        "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyMDAiIGhlaWdodD0iMjAwIj4KICA8IS0tIFRpZ2VyJ3MgQm9keSAtLT4KICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIxMDAiIHI9IjgwIiBmaWxsPSJvcmFuZ2UiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iNSIvPgogIAogIDwhLS0gVGlnZXIncyBTdHJpcGVzIC0tPgogIDxsaW5lIHgxPSI1MCIgeTE9IjcwIiB4Mj0iMTUwIiB5Mj0iNzAiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iNSIvPgogIDxsaW5lIHgxPSI0MCIgeTE9IjEwMCIgeDI9IjE2MCIgeTI9IjEwMCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSI1Ii8+CiAgPGxpbmUgeDE9IjUwIiB5MT0iMTMwIiB4Mj0iMTUwIiB5Mj0iMTMwIiBzdHJva2U9ImJsYWNrIiBzdHJva2Utd2lkdGg9IjUiLz4KICAKICA8IS0tIFRpZ2VyJ3MgRXllcyAtLT4KICA8Y2lyY2xlIGN4PSI3MCIgY3k9IjgwIiByPSIxMCIgZmlsbD0id2hpdGUiLz4KICA8Y2lyY2xlIGN4PSIxMzAiIGN5PSI4MCIgcj0iMTAiIGZpbGw9IndoaXRlIi8+CiAgCiAgPCEtLSBUaWdlcidzIFB1cGlscyAtLT4KICA8Y2lyY2xlIGN4PSI3MCIgY3k9IjgwIiByPSI1IiBmaWxsPSJibGFjayIvPgogIDxjaXJjbGUgY3g9IjEzMCIgY3k9IjgwIiByPSI1IiBmaWxsPSJibGFjayIvPgogIAogIDwhLS0gVGlnZXIncyBOb3NlIC0tPgogIDxwb2x5Z29uIHBvaW50cz0iOTAsMTEwIDExMCwxMTAgMTAwLDEzMCIgZmlsbD0iYmxhY2siLz4KICAKICA8IS0tIFRpZ2VyJ3MgTW91dGggLS0+CiAgPGxpbmUgeDE9IjkwIiB5MT0iMTQwIiB4Mj0iMTEwIiB5Mj0iMTQwIiBzdHJva2U9ImJsYWNrIiBzdHJva2Utd2lkdGg9IjIiLz4KPC9zdmc+Cg==";
    string public constant TIGER_SVG_URI = '';
    string public constant LION_SVG_URI = 'data:application/json;base64,eyJuYW1lIjogIldpbGRMaWZlIE5GVCIsICJkZXNjcmlwdGlvbiI6ICJBbiBORlQgdGhhdCBzaG93cyBLaW5nIG9mIHRoZSBKdW5nbGUhIiwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIndpbGRsaWZlIiwgInZhbHVlIjogMTAwfV0sICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSGRwWkhSb1BTSXlNREFpSUdobGFXZG9kRDBpTWpBd0lqNEtJQ0E4SVMwdElFeHBiMjRuY3lCTllXNWxJQzB0UGdvZ0lEeGphWEpqYkdVZ1kzZzlJakV3TUNJZ1kzazlJakV3TUNJZ2NqMGlPVEFpSUdacGJHdzlJbUp5YjNkdUlpQnpkSEp2YTJVOUltSnNZV05ySWlCemRISnZhMlV0ZDJsa2RHZzlJak1pTHo0S0lDQUtJQ0E4SVMwdElFeHBiMjRuY3lCR1lXTmxJQzB0UGdvZ0lEeGphWEpqYkdVZ1kzZzlJakV3TUNJZ1kzazlJakV3TUNJZ2NqMGlOekFpSUdacGJHdzlJbWR2YkdRaUlITjBjbTlyWlQwaVlteGhZMnNpSUhOMGNtOXJaUzEzYVdSMGFEMGlNeUl2UGdvZ0lBb2dJRHdoTFMwZ1RHbHZiaWR6SUVWNVpYTWdMUzArQ2lBZ1BHTnBjbU5zWlNCamVEMGlOekFpSUdONVBTSTRNQ0lnY2owaU1UQWlJR1pwYkd3OUluZG9hWFJsSWk4K0NpQWdQR05wY21Oc1pTQmplRDBpTVRNd0lpQmplVDBpT0RBaUlISTlJakV3SWlCbWFXeHNQU0ozYUdsMFpTSXZQZ29nSUFvZ0lEd2hMUzBnVEdsdmJpZHpJRkIxY0dsc2N5QXRMVDRLSUNBOFkybHlZMnhsSUdONFBTSTNNQ0lnWTNrOUlqZ3dJaUJ5UFNJMUlpQm1hV3hzUFNKaWJHRmpheUl2UGdvZ0lEeGphWEpqYkdVZ1kzZzlJakV6TUNJZ1kzazlJamd3SWlCeVBTSTFJaUJtYVd4c1BTSmliR0ZqYXlJdlBnb2dJQW9nSUR3aExTMGdUR2x2YmlkeklFNXZjMlVnTFMwK0NpQWdQSEJ2YkhsbmIyNGdjRzlwYm5SelBTSTVNQ3d4TVRBZ01URXdMREV4TUNBeE1EQXNNVE13SWlCbWFXeHNQU0ppYkdGamF5SXZQZ29nSUFvZ0lEd2hMUzBnVEdsdmJpZHpJRTF2ZFhSb0lDMHRQZ29nSUR4c2FXNWxJSGd4UFNJNU1DSWdlVEU5SWpFME1DSWdlREk5SWpFeE1DSWdlVEk5SWpFME1DSWdjM1J5YjJ0bFBTSmliR0ZqYXlJZ2MzUnliMnRsTFhkcFpIUm9QU0l5SWk4K0NpQWdDaUFnUENFdExTQk1hVzl1SjNNZ1YyaHBjMnRsY25NZ0xTMCtDaUFnUEd4cGJtVWdlREU5SWpZd0lpQjVNVDBpTVRJd0lpQjRNajBpT1RBaUlIa3lQU0l4TWpBaUlITjBjbTlyWlQwaVlteGhZMnNpSUhOMGNtOXJaUzEzYVdSMGFEMGlNaUl2UGdvZ0lEeHNhVzVsSUhneFBTSXhNVEFpSUhreFBTSXhNakFpSUhneVBTSXhOREFpSUhreVBTSXhNakFpSUhOMGNtOXJaVDBpWW14aFkyc2lJSE4wY205clpTMTNhV1IwYUQwaU1pSXZQZ284TDNOMlp6NEsifQ==';
    
    function setUp() public {
        deployWildNft = new DeployWildlifeNft();
        wildNft = deployWildNft.run();
        alice = makeAddr("alice");
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(alice);
        wildNft.mintNft();

        assert(wildNft.balanceOf(alice) == 1);
        assert(wildNft.ownerOf(0) == alice);
    }

    function testTokenURIDefaultIsCorrectlySet() public {
        vm.prank(alice);
        wildNft.mintNft();

        assert(
            keccak256(abi.encodePacked(wildNft.tokenURI(0))) ==
                keccak256(abi.encodePacked(LION_SVG_URI))
        );
    }

    function testFlipThroneToTiger() public {
        vm.prank(alice);
        wildNft.mintNft();

        assert(
            keccak256(abi.encodePacked(wildNft.tokenURI(0))) ==
                keccak256(abi.encodePacked(LION_SVG_URI))
        );
        assert(wildNft.getTokenIdToKing(0) == WildlifeNft.King.LION);

        // flip throne
        vm.prank(alice);
        wildNft.flipThrone(0);
        assert(wildNft.getTokenIdToKing(0) == WildlifeNft.King.TIGER);
    }
}
