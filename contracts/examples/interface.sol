// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ERC20的接口 抽象 只声明，不实现
interface IERC20 {
  // 继承接口的合约必须实现以下方法
  function name() external view returns (string memory);
  function symbol() external view returns (string memory);
  function decimals() external view returns (uint8);
}

// IERC20接口的具体实现 继承 接口
contract ERC20 is IERC20 {
    // 内部变量
    string _name = "MyCoin";
    string _symbol = "MYC";
    uint8 _decimals = 18;

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external view returns (uint8) {
        return _decimals;
    }
}

// 使用接口的子合约
contract UseERC20 {
    function getToken() external view returns (string memory, string memory, uint8) {
        // 通过合约地址,构造一个可调用的接口token
        IERC20 token = IERC20(0xE5363f1b12023d5A402D551362746f684B5c6532);
        // 通过token.name()调用具体合约方法
        return (token.name(), token.symbol(), token.decimals());
    }
}













