# PaymentVault

A secure Solidity smart contract for managing ETH payments with owner-controlled withdrawals and built-in security features.

## Overview

PaymentVault provides a secure way to:
- **Accept deposits** from any address via the `receive()` function or explicit `deposit()` call
- **Withdraw funds** under owner control only
- **Track transactions** through emitted events
- **Emergency controls** via pause/unpause mechanism

## Features

- ✅ Receive ETH payments directly
- ✅ Owner-controlled withdrawals
- ✅ Event logging for deposits and withdrawals
- ✅ Safe transfer mechanism using low-level call
- ✅ Balance tracking per user
- ✅ Reentrancy protection
- ✅ Minimum deposit enforcement (0.001 ETH)
- ✅ Emergency pause functionality
- ✅ Ownership transfer support
- ✅ Withdraw all funds in one tx

## Installation

```bash
git clone https://github.com/your-repo/payment-vault.git
cd payment-vault
forge install
```

## Build

```bash
forge build
```

## Test

```bash
forge test
```

## Deploy

Create a `.env` file:
```
PRIVATE_KEY=your_private_key
RPC_URL=your_rpc_url
ETHERSCAN_API_KEY=your_api_key
```

Deploy to network:
```bash
source .env
forge script script/DeployPaymentVault.s.sol --rpc-url $RPC_URL --broadcast --verify
```

## Usage

### Deposit ETH
```solidity
// Direct transfer
payable(vaultAddress).transfer(1 ether);

// Or via deposit function
vault.deposit{value: 1 ether}();
```

### Withdraw (Owner only)
```solidity
vault.withdraw(0.5 ether);
vault.withdrawAll();
```

### Emergency Controls
```solidity
vault.pause();   // Stop all deposits/withdrawals
vault.unpause(); // Resume operations
```

## Security

- Reentrancy guard on withdrawals
- Pausable in case of emergency
- Minimum deposit to prevent spam
- Ownership can be transferred securely

## License

MIT

