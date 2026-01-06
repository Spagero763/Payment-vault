// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {PaymentVault} from "../src/PaymentVault.sol";
import {Script} from "forge-std/Script.sol";

contract DeployPaymentVault is Script {
    function run() external returns (PaymentVault){
        vm.startBroadcast();
        PaymentVault paymentvault = new PaymentVault();
        vm.stopBroadcast();
        return paymentvault;
    }
}