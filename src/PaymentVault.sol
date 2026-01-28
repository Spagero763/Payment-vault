// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PaymentVault {
    address public owner;
    bool private locked;
    uint256 public constant MIN_DEPOSIT = 0.001 ether;

    event Deposit(address indexed from, uint256 amount);
    event Withdraw(address indexed to, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier noReentrant() {
        require(!locked, "Reentrant call");
        locked = true;
        _;
        locked = false;
    }

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
        require(msg.value >= MIN_DEPOSIT, "Below minimum deposit");
        emit Deposit(msg.sender, msg.value);
    }

    // Withdraw ETH
    function withdraw(uint256 amount) external onlyOwner noReentrant {
        require(amount <= address(this).balance, "Insufficient balance");

        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdraw(owner, amount);
    }

    // Check balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Transfer ownership to new address
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
