# PaymentVault

A simple and secure Solidity smart contract for managing ETH payments with owner-controlled withdrawals.

## Overview

PaymentVault is a minimalist contract that provides a secure way to:
- **Accept deposits** from any address via the `receive()` function or explicit `deposit()` call
- **Withdraw funds** under owner control only
- **Track transactions** through emitted events

## Features

- ✅ Receive ETH payments directly
- ✅ Owner-controlled withdrawals
- ✅ Event logging for deposits and withdrawals
- ✅ Safe transfer mechanism using low-level call
- ✅ Balance tracking

