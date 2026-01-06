// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PaymentVault {
    address public owner;

    event Deposit(address indexed from, uint256 amount);
    event Withdraw(address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Accept ETH
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // Deposit function (optional, clearer than receive)
    function deposit() external payable {
        require(msg.value > 0, "Zero amount");
        emit Deposit(msg.sender, msg.value);
    }

    // Withdraw ETH
    function withdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");

        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdraw(owner, amount);
    }

    // Check balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
