// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// 计数器合约 实现一个计数器
contract Counter {
    // 合约外部可以访问计数器
    uint256 public count;

    // 实现计数方法
    function increment() external {
        count += 1;
    }
}

// 接口 抽象合约
interface ICounter {
    function count() external view returns (uint256);

    function increment() external;
}

// 调用接口具体实现了的方法
contract MyContract {
    function incrementCounter(address _counter) external {
        // 构造接口
        ICounter counter = ICounter(_counter);
        counter.increment();
        // ICounter(_counter).increment();
    }

    function getCount(address _counter) external view returns (uint256) {
        // 直接使用接口
        return ICounter(_counter).count();
    }
}

// Uniswap example
interface UniswapV2Factory {
    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);
}

interface UniswapV2Pair {
    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

contract UniswapExample {
    address private factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function getTokenReserves() external view returns (uint256, uint256) {
        address pair = UniswapV2Factory(factory).getPair(dai, weth);
        (uint256 reserve0, uint256 reserve1,) =
            UniswapV2Pair(pair).getReserves();
        return (reserve0, reserve1);
    }
}
