// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/DauphineToken.sol";

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
