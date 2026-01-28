// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PaymentVault {
    address public owner;
    bool private locked;
    bool public paused;
    uint256 public constant MIN_DEPOSIT = 0.001 ether;
    uint256 public totalDeposited;
    
    mapping(address => uint256) public deposits;

    event Deposit(address indexed from, uint256 amount);
    event Withdraw(address indexed to, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Paused(address account);
    event Unpaused(address account);

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

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Accept ETH
    receive() external payable {
        require(!paused, "Contract is paused");
        deposits[msg.sender] += msg.value;
        totalDeposited += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Deposit function (optional, clearer than receive)
    function deposit() external payable whenNotPaused {
        require(msg.value >= MIN_DEPOSIT, "Below minimum deposit");
        deposits[msg.sender] += msg.value;
        totalDeposited += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Withdraw ETH
    function withdraw(uint256 amount) external onlyOwner noReentrant whenNotPaused {
        require(amount <= address(this).balance, "Insufficient balance");

        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdraw(owner, amount);
    }

    // Withdraw all ETH from vault
    function withdrawAll() external onlyOwner noReentrant whenNotPaused {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Transfer failed");

        emit Withdraw(owner, balance);
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

    // Pause contract
    function pause() external onlyOwner {
        paused = true;
        emit Paused(msg.sender);
    }

    // Unpause contract
    function unpause() external onlyOwner {
        paused = false;
        emit Unpaused(msg.sender);
    }
}
