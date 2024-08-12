// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 引入代币合约需要继承的 openzeppelin 的 ERC-20 合约
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DataPunkCoin is ERC20{
    // 构造函数，调用了openzeppelin的ERC-20合约的构造函数，传入代币名称和符号
    constructor() ERC20("DataPunk Coin", "DPC") {
        // 铸造 100 个 DPC 给合约部署者
        _mint(msg.sender, 100*10**18);
    }
}