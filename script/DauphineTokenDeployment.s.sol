// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/DauphineToken.sol";

/// @title Dauphine Token Deployment
/// @author Jean-Baptiste Astruc
/// @notice Script to deploy the Dauphine Token

contract DauphineTokenDeployment is Script {
    function run() external {
        // Start broadcasting transactions.
        vm.startBroadcast();

        // Deploy the token contract.
        DauphineToken token = new DauphineToken();

        // Log the deployed contract address.
        console.log("DauphineToken deployed at:", address(token));

        // Stop broadcasting.
        vm.stopBroadcast();
    }
}
