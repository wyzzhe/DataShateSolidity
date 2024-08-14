// TODO
// 1. 自己实现授权allow函数
// 2. 数据集创建者改为单人或多人
// 3. 实现验证者提取数据限制

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DataPunkCoin.sol";

// 数据集交互合约
contract DataPunk {
    address private _owner;
    address public dpkContractAddress;
    bool public isDataPunkCoinDeployed = false;
    uint256 public makeDatasePrice = 10;
    address[] public publicValidators;
    uint256 immutable UPDATAREWARD = 100;
    uint256 immutable SUMSUPPLY = 100 * 10**18;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event DatasetUpload(uint256 indexed datasetId, address indexed creator, uint256 reward);
    event DatasetPurchased(uint256 indexed datasetId, address indexed purchaser, uint256 cost);
    event DatasetMaked(uint256 indexed datasetId, address indexed maker, uint256 cost);
    event DatasetValidated(uint256 indexed datasetId, address indexed validator, uint256 reward);
    event DataPunkCoinDeployed(address tokenAddress);
    event ValidatorRegistered(address indexed validator);
    
    // 数据集结构体
    struct Dataset {
        address creator;
        uint256 price;
        uint256 validationReward;
        address[] validators;
        bool isValidated;
    }

    Dataset[] public datasets;

    // 初始化合约，将合约部署者设置为初始拥有者
    constructor() {
        // 将合约部署者设置为初始拥有者
       _owner = msg.sender;
    }

    // 如果由拥有者以外的任何帐户调用，则抛出异常
    modifier onlyOwner() {
        // 确保调用者是合约的拥有者
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        // 继续执行被修饰的函数
        _;
    }

    // 创建 DataPunkCoin 合约
    function deployDataPunkCoin() public onlyOwner {
        require(!isDataPunkCoinDeployed, "DataPunkCoin has already been deployed");

        // 创建 DataPunkCoin 合约
        DataPunkCoin dpcContract = new DataPunkCoin();

        dpkContractAddress = address(dpcContract);

        // 接口具体实现方法
        // dpcToken = IERC20(dpkContractAddress);

        isDataPunkCoinDeployed = true; // 设置标记，表示已经部署过

        emit DataPunkCoinDeployed(dpkContractAddress);
    }

    // 获取所有验证者的函数
    function getAllValidators() public view returns (address[] memory) {
        return publicValidators;
    }

    // 获取所有数据集信息
    function getAllDatasets() public view returns (
        address[] memory creators,
        uint256[] memory prices,
        uint256[] memory validationRewards,
        bool[] memory isValidatedFlags
    ) {
        uint256 datasetCount = datasets.length;

        creators = new address[](datasetCount);
        prices = new uint256[](datasetCount);
        validationRewards = new uint256[](datasetCount);
        isValidatedFlags = new bool[](datasetCount);

        for (uint256 i = 0; i < datasetCount; i++) {
            Dataset storage dataset = datasets[i];
            creators[i] = dataset.creator;
            prices[i] = dataset.price;
            validationRewards[i] = dataset.validationReward;
            isValidatedFlags[i] = dataset.isValidated;
        }

        return (creators, prices, validationRewards, isValidatedFlags);
    }

    // 获取当前合约拥有者的地址
    function owner() public view virtual returns (address) {
        return _owner;
    }

    // 获取DPC supply
    function getDPCSupply() public view returns (uint256) {
        // return dpcToken.totalSupply();
    }

    // 获取DPC 账户余额
    function getDPCBalanceOf(address account) public view returns (uint256) {
        // return dpcToken.balanceOf(account);
    }

    // 上传新的数据集
    function updateDataset(uint256 price, uint256 validationReward) public returns (uint256) {
        address[] memory emptyArray;
        datasets.push(Dataset({
            creator: msg.sender,
            price: price,
            validationReward: validationReward,
            validators: emptyArray,
            isValidated: false
        }));
        uint256 datasetId = datasets.length - 1;

        // 奖励创建者
        // require(dpcToken.balanceOf(address(this)) >= price, "Contract has insufficient DPC to reward");
        // dpcToken.transfer(msg.sender, UPDATAREWARD);

        emit DatasetUpload(datasetId, msg.sender, price);
        return datasetId;
    }

    // 购买数据集使用权
    function purchaseDataset(uint256 datasetId) public {
        Dataset storage dataset = datasets[datasetId];
        // require(dpcToken.balanceOf(msg.sender) >= dataset.price, "Insufficient balance to purchase");
        require(msg.sender != dataset.creator, "Cannot buy yours dataset");

        // dpcToken.approve(address(this), dataset.price);
        // dpcToken.transferFrom(msg.sender, dataset.creator, dataset.price);

        emit DatasetPurchased(datasetId, msg.sender, dataset.price);
    }

    // 制造数据集
    function makeDataset(uint256 price, uint256 validationReward) public {
        // require(dpcToken.balanceOf(msg.sender) >= makeDatasePrice, "Insufficient balance to purchase");
        
        address[] memory emptyArray;
        datasets.push(Dataset({
            creator: msg.sender,
            price: price,
            validationReward: validationReward,
            validators: emptyArray,
            isValidated: true
        }));
        uint256 datasetId = datasets.length - 1;

        // dpcToken.transferFrom(msg.sender, address(this), makeDatasePrice);

        emit DatasetMaked(datasetId, msg.sender, makeDatasePrice);
    }

    // 暂时谁都可以登记成为验证者
    function registerAsValidator() public {
        publicValidators.push(msg.sender);
        emit ValidatorRegistered(msg.sender);
    }

    // 验证数据集
    function validateDataset(uint256 datasetId) public {
        Dataset storage dataset = datasets[datasetId];
        require(!dataset.isValidated, "Dataset already validated");

        // 检查调用者是否为已登记的验证者
        bool isValidator = false;
        for (uint i = 0; i < publicValidators.length; i++) {
            if (publicValidators[i] == msg.sender) {
                isValidator = true;
                break;
            }
        }
        require(isValidator, "You must be a registered validator");
        // 检查验证者不能是数据集的创建者
        require(msg.sender != dataset.creator, "Validator cannot be the creator");

        // 添加验证者到数据集的验证者列表中
        dataset.validators.push(msg.sender);
        // dpcToken.transfer(msg.sender, dataset.validationReward);

        // 暂时只有单个验证者验证，数据集标记为已验证
        dataset.isValidated = true;

        // 奖励验证者
        // require(dpcToken.balanceOf(address(this)) >= dataset.validationReward, "Insufficient balance to reward");
        // dpcToken.transfer(msg.sender, dataset.validationReward);

        emit DatasetValidated(datasetId, msg.sender, dataset.validationReward);
    }
}