// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {PaymentVault} from "../src/PaymentVault.sol";

contract PaymentVaultTest is Test {
    PaymentVault vault;
    address owner;
    address user1;
    address user2;

    function setUp() public {
        owner = address(this);
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        
        vault = new PaymentVault();
        
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }

    function test_OwnerIsDeployer() public view {
        assertEq(vault.owner(), owner);
    }

    function test_DepositUpdatesBalance() public {
        vm.prank(user1);
        vault.deposit{value: 1 ether}();
        
        assertEq(vault.getBalance(), 1 ether);
        assertEq(vault.deposits(user1), 1 ether);
    }

    function test_RevertWhenDepositBelowMinimum() public {
        vm.prank(user1);
        vm.expectRevert("Below minimum deposit");
        vault.deposit{value: 0.0001 ether}();
    }

    function test_WithdrawByOwner() public {
        vm.prank(user1);
        vault.deposit{value: 2 ether}();
        
        uint256 balanceBefore = owner.balance;
        vault.withdraw(1 ether);
        
        assertEq(owner.balance, balanceBefore + 1 ether);
    }

    function test_RevertWithdrawNotOwner() public {
        vm.prank(user1);
        vault.deposit{value: 1 ether}();
        
        vm.prank(user1);
        vm.expectRevert("Not owner");
        vault.withdraw(1 ether);
    }

    function test_PauseBlocksDeposits() public {
        vault.pause();
        
        vm.prank(user1);
        vm.expectRevert("Contract is paused");
        vault.deposit{value: 1 ether}();
    }

    function test_TransferOwnership() public {
        vault.transferOwnership(user1);
        assertEq(vault.owner(), user1);
    }

    function test_WithdrawAll() public {
        vm.prank(user1);
        vault.deposit{value: 3 ether}();
        
        uint256 balanceBefore = owner.balance;
        vault.withdrawAll();
        
        assertEq(owner.balance, balanceBefore + 3 ether);
        assertEq(vault.getBalance(), 0);
    }

    receive() external payable {}
}
