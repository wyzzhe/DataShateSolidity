// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 抽象合约 人 不能单独部署 包含至少一个未实现的函数 得到薪水
abstract contract Person{
  string public name;
  uint public age;
  
  // 使用 virtual，表示函数可以被子合约覆盖
  function getSalary() public pure virtual returns(uint);
}

// 具体合约 职员 继承 人 自动拥有父合约的变量(自动初始化为0)和函数(需要在子函数中具体实现)
contract Employee is Person {
    // 使用 override，表示覆盖了子合约的同名函数
    function getSalary() public pure override returns(uint){
      // 得到薪水方法的具体实现
      return 3000;
    }
}