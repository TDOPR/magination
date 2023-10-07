// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.0;
 
contract MultiMagicion is Ownable {

    using SafeMath for uint256;
    using SafeMath for uint8;

    struct User {
        uint id;
        address referrer;
        uint partnersCount;
        uint registime;
        uint ordertime;
        uint256 allowance;
        uint256 allowanceBalance;
        uint256 recalvalue;
        uint8 nftAmount;
        uint256 totalMFSAmount;
        uint8 reinvesttimes;
    }
 
    struct NodeAward {
        address currentReferrer;
        address[] beginnerNodeReferrals;
        address[] middleNodeReferrals;
        address[] advanceNodeReferrals;
        uint8 level;
        uint teamTotalValue;
        uint8 reinvestCount;
    }

    event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId, uint registime);
    event Upgrade(address indexed user, uint8 level);
    event BuyNewNft(address indexed user, uint indexed nftAmount, uint indexed allowance);
    event SentExtraMFSDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
    event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
    event MissedMFSReceive(address indexed receiver, address indexed from, uint8 level);
    event CreatNode(address indexed user, address indexed referrer, uint indexed level);

    mapping(address => User) public users;
    mapping(uint => address) public idToAddress;
    mapping(uint8 => uint256) public levelPrice;
    mapping(uint8 => bool) public NodeLevels; 
    mapping(address => NodeAward) public Team;
    mapping(address => uint256) public AwardValue;
    mapping(address => uint256) public usdtBalance;

    uint8 public constant LAST_LEVEL = 4;
    uint8 dnaModules = 11;
    bool Locked;
    address public owner;
    uint public lastUserId = 2;
    IERC20 public mfsToken;
    IERC20 public usdtToken;
    uint8 priceRate = 50;

    constructor(address ownerAddress, address _mfsTokenAddress) public {

        usdtToken = IERC20("0x55d398326f99059ff775485246999027b3197955");
        mfsToken = IERC20(_mfsTokenAddress);
        levelPrice[0] = 2500;
        levelPrice[1] = 5000;
        levelPrice[2] = 25000;
        for (uint8 i = 3; i <= LAST_LEVEL; i++) {
            levelPrice[i] = levelPrice[i-1] * 2;
        }
        
        owner = ownerAddress;      
    }

    function setPriceRate(_priceRate) public onlyOwner {
        priceRate = _priceRate;
    }

    function _generateRandDna(uint _id) /** 通过用户id和block.timestamp生成随机数 */
        public
        view
        returns (uint8)
    {
        return
            uint8(keccak256(abi.encodePacked(_id, block.timestamp))).tryMod(dnaModules);
    }

    fallback() external payable {
       
    }

    function usdtTomfs(uint256 usdt) private pure returns (uint256) {
        uint256 mfsAmount = usdt * priceRate;
        return mfsAmount;
    }

    function registration(address userAddress, address referrerAddress, uint256 _mfsAmount) private {
        require(usdtBalance[userAddress] >= 50, "USDT insufficient");
        // require(_mfsAmount >= 2500, "registration cost 2500MFS");
        require(!isUserExists(userAddress), "user exists");
        require(isUserExists(referrerAddress), "referrer not exists");

        uint32 size;
        assembly {
            size := extcodesize(userAddress)
        }
        require(size == 0, "cannot be a contract");
        
        User memory user = User({
            id: lastUserId,
            referrer: referrerAddress,
            partnersCount: 0,
            registime: block.timestamp,
            ordertime: block.timestamp,
            totalMFSAmount: _mfsAmount,
            allowance: 0,
            allowanceBalance: 0,
            recalvalue: 0,
            nftAmount: 0,
            reinvesttimes: 0
        });
        
        users[userAddress].totalMFSAmount = usdtTomfs(usdtBalance[userAddress]);
        users[userAddress] = user;
        users[userAddress].allowance = _allowances(userAddress, lastUserId);
        users[userAddress].allowanceBalance = _allowances(userAddress, lastUserId);
        idToAddress[lastUserId] = userAddress;
        Team[userAddress].level = 0;
        AwardValue[userAddress] = 0;
              
        users[userAddress].referrer = referrerAddress;
        lastUserId++;   
        users[userAddress].nftAmount++;
        users[referrerAddress].partnersCount++;  
        sendShareMFSDividends(userAddress, _mfsAmount);
        emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id, users[userAddress].registime);
    }

    function _allowances(address userAddress, uint _id) private view returns (uint256) {
        uint256 randDna =  _generateRandDna(_id);
        if (randDna < 2) {
            randDna = 5;
        }
        uint256 allowance = users[userAddress].totalMFSAmount.tryMul(randDna);
        return allowance;
    }
    
    function buyNewNft(address userAddress, uint256 _usdtAmount) external payable {
        require(isUserExists(userAddress), "user is not exists. Register first.");
        usdtToken._approve(msg.sender, address(this), _usdtAmount);
        usdtToken._transfer(msg.sender, address(this), _usdtAmount);
        uint256 mfsAmount = usdtTomfs(_usdtAmount);
        users[userAddress].recalvalue += (block.timestamp - users[userAddress].ordertime).tryDiv(86400).tryMul(users[userAddress].totalMFSAmount).tryDiv(100);
        users[userAddress].ordertime = block.timestamp;
        users[userAddress].totalMFSAmount += _mfsAmount;
        users[userAddress].allowance = _allowances(userAddress, lastUserId);
        users[userAddress].nftAmount++;

        sendShareMFSDividends(userAddress, _mfsAmount);
        
        emit BuyNewNft(userAddress, users[userAddress].nftAmount, users[userAddress].allowance);
    }

    function createNode(address userAddress, uint8 level, uint256 _mfsAmount) external payable {
        require(isUserExists(userAddress), "user is not exists. Register first.");       
        require((users[userAddress].totalMFSAmount + _mfsAmount) == levelPrice[level], "invalid price");
        require(level >= 1 && level <= LAST_LEVEL, "invalid level");
        require(!NodeLevels[Team[userAddress].level], "level already activated");

        if (level == 1) {
            require(users[userAddress].partnersCount >= 5, "invalid referrals amount");
            require(Team[userAddress].teamTotalValue >= 2500000, "invalid team total value");
            NodeLevels[Team[userAddress].level] = true;
            Team[users[userAddress].referrer].beginnerNodeReferrals.push();
           
            emit Upgrade(userAddress, level);

        }   else if (level == 2) {
            require(Team[userAddress].beginnerNodeReferrals.length >= 2, "invalid referrals node amount");
            NodeLevels[Team[userAddress].level] = true;
            Team[users[userAddress].referrer].middleNodeReferrals.push();

            emit Upgrade(userAddress, level);
        }   else if (level == 3) {
            require(Team[userAddress].middleNodeReferrals.length >= 2, "invalid referrals node amount");
            NodeLevels[Team[userAddress].level] = true;
            Team[users[userAddress].referrer].advanceNodeReferrals.push();

            emit Upgrade(userAddress, level);
        }  else if (level == 4) {
            require(Team[userAddress].advanceNodeReferrals.length >= 2, "invalid referrals node amount");
            NodeLevels[Team[userAddress].level] = true;

            emit Upgrade(userAddress, level);
        }

        Team[userAddress].level = level;
        address freeNodeReferrer = findFreeNodeReferrer(userAddress);
        Team[userAddress].currentReferrer = freeNodeReferrer;
        Team[userAddress].reinvestCount++;
        sendNodeMFSDividends(freeNodeReferrer, userAddress,  _mfsAmount);
        sendShareMFSDividends(userAddress, _mfsAmount);

        emit CreatNode(userAddress, freeNodeReferrer, level);
    }

    function isUserExists(address user) public view returns (bool) {
        return (users[user].id != 0);
    }

    function findFreeNodeReferrer(address userAddress, uint8 level) public returns(address) {
            
            if (Team[userAddress].level == 4 && Team[users[userAddress].referrer].level == 4) {
                return Team[userAddress].currentReferrer;
            } else if (Team[userAddress].level == 4 && Team[users[userAddress].referrer].level < 4) {
                Team[userAddress].currentReferrer = address(0);
                return Team[userAddress].currentReferrer;
            }
        while (true) {
        
            if (Team[users[userAddress].referrer].level > level) {
                Team[userAddress].currentReferrer = users[userAddress].referrer;
                return Team[userAddress].currentReferrer;
            }

            userAddress = users[userAddress].referrer;
        }
    }

    function sendNodeMFSDividends(address userAddress, uint256 level, uint256 _mfsAmount) private  {
        address recieveAddress = findFreeNodeReferrer(_from, level);
        uint256 sendMFSAmount = _mfsAmount;
        if (Team[recieveAddress].level == 2) {
            require(users[recieveAddress].allowanceBalance > 0, "allowace balance insufficient");
            if (users[recieveAddress].allowanceBalance > ((_mfsAmount).tryMul(8).tryDiv(100))) {
                        AwardValue[recieveAddress] += _mfsAmount * 8 / 100;
                        users[recieveAddress].allowanceBalance -= _mfsAmount * 8 / 100;
                    } else {
                        AwardValue[recieveAddress] += users[recieveAddress].allowanceBalance;
                        users[recieveAddress].allowanceBalance = 0;
                    }
            address nextRecieveAddress = findFreeNodeReferrer(recieveAddress, level);
            if (Team[nextRecieveAddress].level == 3) {
                require(users[nextRecieveAddress].allowanceBalance > 0, "allowace balance insufficient");
                if (users[nextRecieveAddress].allowanceBalance > (_mfsAmount * 3 / 100)) {
                        AwardValue[nextRecieveAddress] += _mfsAmount * 3 / 100;
                        users[nextRecieveAddress].allowanceBalance -= _mfsAmount * 3 / 100;
                    } else {
                        AwardValue[nextRecieveAddress] += users[nextRecieveAddress].allowanceBalance;
                        users[nextRecieveAddress].allowanceBalance = 0;
                    }
                nextRecieveAddress = findFreeNodeReferrer(nextRecieveAddress, level);
                if (Team[nextRecieveAddress].level == 4) {
                    require(users[nextRecieveAddress].allowanceBalance > 0, "allowace balance insufficient");
                    if (users[nextRecieveAddress].allowanceBalance > (_mfsAmount * 4 / 100)) {
                        AwardValue[nextRecieveAddress] += _mfsAmount * 4 / 100;
                        users[nextRecieveAddress].allowanceBalance -= _mfsAmount * 4 / 100;
                    } else {
                        AwardValue[nextRecieveAddress] += users[nextRecieveAddress].allowanceBalance;
                        users[nextRecieveAddress].allowanceBalance = 0;
                    }
                    nextRecieveAddress = findFreeNodeReferrer(nextRecieveAddress, level);
                    if (Team[nextRecieveAddress].level == 4) {
                        require(users[nextRecieveAddress].allowanceBalance > 0, "allowace balance insufficient");
                        if (users[nextRecieveAddress].allowanceBalance > (_mfsAmount * 40 / 10000)) {
                            AwardValue[nextRecieveAddress] += _mfsAmount * 40 / 10000;
                            users[nextRecieveAddress].allowanceBalance -= _mfsAmount * 40 / 10000;
                        } else {
                            AwardValue[nextRecieveAddress] += users[nextRecieveAddress].allowanceBalance;
                            users[nextRecieveAddress].allowanceBalance = 0;
                        }
                    }
                }
            }
        } else if (Team[recieveAddress].level == 3) {
            require(users[recieveAddress].allowanceBalance > 0, "allowace balance insufficient");
                    if (users[recieveAddress].allowanceBalance > (_mfsAmount * 11 / 100)) {
                        AwardValue[recieveAddress] += _mfsAmount * 11 / 100;
                        users[recieveAddress].allowanceBalance -= _mfsAmount * 11 / 100;
                    } else {
                        AwardValue[recieveAddress] += users[recieveAddress].allowanceBalance;
                        users[recieveAddress].allowanceBalance = 0;
                    }
            address nextRecieveAddress = findFreeNodeReferrer(recieveAddress, level);
                if (Team[nextRecieveAddress].level == 4) {
                    require(users[nextRecieveAddress].allowanceBalance > 0, "allowace balance insufficient");
                        if (users[nextRecieveAddress].allowanceBalance > (_mfsAmount * 4 / 100)) {
                            AwardValue[nextRecieveAddress] += _mfsAmount * 4 / 100;
                            users[nextRecieveAddress].allowanceBalance -= _mfsAmount * 4 / 100;
                        } else {
                            AwardValue[nextRecieveAddress] += users[nextRecieveAddress].allowanceBalance;
                            users[nextRecieveAddress].allowanceBalance = 0;
                        }
                        nextRecieveAddress = findFreeNodeReferrer(nextRecieveAddress, level);
                        if (Team[nextRecieveAddress].level == 4) {
                            require(users[nextRecieveAddress].allowanceBalance > 0, "allowace balance insufficient");
                            if (users[nextRecieveAddress].allowanceBalance > (_mfsAmount * 40 / 10000)) {
                                AwardValue[nextRecieveAddress] += _mfsAmount * 40 / 10000;
                                users[nextRecieveAddress].allowanceBalance -= _mfsAmount * 40 / 10000;
                            } else {
                                AwardValue[nextRecieveAddress] += users[nextRecieveAddress].allowanceBalance;
                                users[nextRecieveAddress].allowanceBalance = 0;
                            }
                        }
                }
        } else if (Team[recieveAddress].level == 4) {
            require(users[recieveAddress].allowanceBalance > 0, "allowace balance insufficient");
                    if (users[recieveAddress].allowanceBalance > (_mfsAmount * 15 / 100)) {
                        AwardValue[recieveAddress] += _mfsAmount * 15 / 100;
                        users[recieveAddress].allowanceBalance -= _mfsAmount * 15 / 100;
                    } else {
                        AwardValue[recieveAddress] += users[recieveAddress].allowanceBalance;
                        users[recieveAddress].allowanceBalance = 0;
                    }
             address nextRecieveAddress = findFreeNodeReferrer(recieveAddress, level);
            if (Team[nextRecieveAddress].level == 4) {
                require(users[nextRecieveAddress].allowanceBalance > 0, "allowace balance insufficient");
                    if (users[nextRecieveAddress].allowanceBalance > (_mfsAmount * 40 / 100)) {
                        AwardValue[nextRecieveAddress] += _mfsAmount * 40 / 100;
                        users[nextRecieveAddress].allowanceBalance -= _mfsAmount * 40 / 100;
                    } else {
                        AwardValue[nextRecieveAddress] += users[nextRecieveAddress].allowanceBalance;
                        users[nextRecieveAddress].allowanceBalance = 0;
                    }
            }
        }
    }

    function sendShareMFSDividends(address userAddress, uint256 _mfsAmount) private {
        
        uint8 count = 1;

        while (true) {
            if (users[users[userAddress].referrer].id != 0) {

                if (users[users[userAddress].referrer].partnersCount >= count && count == 1) {
                    if (Team[users[userAddress].referrer].level == 1 && count <= 20) {
                        Team[users[userAddress].referrer].teamTotalValue += _mfsAmount;
                    }
                    require(users[users[userAddress].referrer].allowanceBalance > 0, "allowace balance insufficient");
                    if (users[users[userAddress].referrer].allowanceBalance > (_mfsAmount * 15 / 100)) {
                        AwardValue[users[userAddress].referrer] += _mfsAmount * 15 / 100;
                        users[users[userAddress].referrer].allowanceBalance -= _mfsAmount * 15 / 100;
                    } else {
                        AwardValue[users[userAddress].referrer] += users[users[userAddress].referrer].allowanceBalance;
                        users[users[userAddress].referrer].allowanceBalance = 0;
                    }
                } else if (users[users[userAddress].referrer].partnersCount >= count && count == 2) {
                    if (Team[users[userAddress].referrer].level == 1 && count <= 20) {
                        Team[users[userAddress].referrer].teamTotalValue += _mfsAmount;
                    }
                    require(users[users[userAddress].referrer].allowanceBalance > 0, "allowace balance insufficient");
                    if (users[users[userAddress].referrer].allowanceBalance > (_mfsAmount * 10 / 100)) {
                        AwardValue[users[userAddress].referrer] += _mfsAmount * 10 / 100;
                        users[users[userAddress].referrer].allowanceBalance -= _mfsAmount * 10 / 100;
                    } else {
                        AwardValue[users[userAddress].referrer] += users[users[userAddress].referrer].allowanceBalance;
                        users[users[userAddress].referrer].allowanceBalance = 0;
                    }
                } else if (users[users[userAddress].referrer].partnersCount >= count && count >= 3 && count <= 5) {
                    if (Team[users[userAddress].referrer].level == 1 && count <= 20) {
                        Team[users[userAddress].referrer].teamTotalValue += _mfsAmount;
                    }
                    require(users[users[userAddress].referrer].allowanceBalance > 0, "allowace balance insufficient");
                    if (users[users[userAddress].referrer].allowanceBalance > (_mfsAmount * 5 / 100)) {
                        AwardValue[users[userAddress].referrer] += _mfsAmount * 5 / 100;
                        users[users[userAddress].referrer].allowanceBalance -= _mfsAmount * 5 / 100;
                    } else {
                        AwardValue[users[userAddress].referrer] += users[users[userAddress].referrer].allowanceBalance;
                        users[users[userAddress].referrer].allowanceBalance = 0;
                    }
                } else if (users[users[userAddress].referrer].partnersCount >= count && count >= 6 && count <= 10) {
                    if (Team[users[userAddress].referrer].level == 1 && count <= 20) {
                       Team[users[userAddress].referrer].teamTotalValue += _mfsAmount;
                    }
                    require(users[users[userAddress].referrer].allowanceBalance > 0, "allowace balance insufficient");
                    if (users[users[userAddress].referrer].allowanceBalance > (users[userAddress].totalMFSAmount * 15 / 100)) {
                        AwardValue[users[userAddress].referrer] += _mfsAmount * 2 / 100;
                        users[users[userAddress].referrer].allowanceBalance -= _mfsAmount * 2 / 100;
                    } else {
                        AwardValue[users[userAddress].referrer] += users[users[userAddress].referrer].allowanceBalance;
                        users[users[userAddress].referrer].allowanceBalance = 0;
                    }
                } else if (Team[users[userAddress].referrer].level == 1 && count <= 20) {
                    Team[users[userAddress].referrer].teamTotalValue += _mfsAmount; 
            } else {
                return;
            }

            }

                userAddress = users[userAddress].referrer;
                count++;
        }
    }

    modifier noReentrancy() {
        require(!Locked, "No reentrancy");

        Locked = true;
        _;
        Locked = false;
    }

    function withdraw(address userAddress) public noReentrancy {
        
            _transfer(address(this), msg.sender, AwardValue[userAddress]);
        
    }

    function userData(address userAddress) public view returns (address, address, uint256, uint8, uint256, uint256, uint256, uint256, uint256, uint256, uint256) {

        return (
                users[userAddress].referrer,
                Team[userAddress].currentReferrer,
                AwardValue[userAddress],
                users[userAddress].partnersCount,
                Team[userAddress].level,
                users[userAddress].allowance,
                users[userAddress].allowanceBalance,
                users[userAddress].reinvesttimes,
                Team[userAddress].reinvestCount,
                Team[userAddress].totalMFSAmount,
                Team[userAddress].teamTotalValue
                );

    }
}
