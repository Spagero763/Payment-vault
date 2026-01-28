// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {PaymentVault} from "../src/PaymentVault.sol";
import {Script, console} from "forge-std/Script.sol";

contract DeployPaymentVault is Script {
    function run() external returns (PaymentVault) {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerKey);
        
        PaymentVault vault = new PaymentVault();
        
        console.log("PaymentVault deployed at:", address(vault));
        console.log("Owner:", vault.owner());
        console.log("Min deposit:", vault.MIN_DEPOSIT());
        
        vm.stopBroadcast();
        
        return vault;
    }
}