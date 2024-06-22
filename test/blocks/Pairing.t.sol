// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console2.sol";
import {
    G1Point, 
    G2Point
    }  from "./Structs.sol";

interface IPairing {
    function pairing(G1Point[] memory p1, G2Point[] memory p2) external returns (bool);
    function pairingProd2(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2)
        external
        returns (bool);
}