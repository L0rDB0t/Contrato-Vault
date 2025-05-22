// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vault is ReentrancyGuard, Ownable {
    uint256 public totalAssets;
    mapping(address => uint256) public balances;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    function deposit(uint256 amount) external payable nonReentrant {
        require(amount > 0, "Amount must be > 0");
        balances[msg.sender] += amount;
        totalAssets += amount;
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) external nonReentrant {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        totalAssets -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        emit Withdraw(msg.sender, amount);
    }
}