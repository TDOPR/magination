// SPDX-License-Identifier: MIT

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

pragma solidity ^0.8.0;

contract MultiMagicion {

    using SafeMathChainlink for uint256;

    struct User {
        uint id;
        address referrer;
        uint partnersCount;
        uint registime;
        uint ordertime;
        uint256 allowance;
        uint256 allowanceBalance;
        uint8 calvalue;
        uint8 recalvalue;
        uint8 nftAmount;
        uint8 level;
        uint256 totalMFSAmout;
        uint8 reinvesttimes;
        uint256 receiveAwardValue;

        mapping(uint8 => bool) NodeLevels; 
        mapping(uint8 => ShareAward) Share;
        mapping(uint8 => NodeAward) Team;
        mapping(address => uint256) AwardValue;
    }

    struct ShareAward {
        address currentReferrer;
    }
    
    struct NodeAward {
        address currentReferrer;
        address[] beginnerNodeReferrals;
        address[] middleNodeReferrals;
        address[] advanceNodeReferrals;
        bool blocked;
        uint level;
        uint TeamTotalValue;
    }

    uint8 public constant LAST_LEVEL = 4;
    uint8 dnaModules = 11;

    event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId, uint registime);
    event Upgrade(address indexed user, uint8 level);
    event BuyNewNft(address indexed user, uint indexed nftAmount, uint indexed allowance);
    event SentExtraMFSDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
    event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
    event MissedMFSReceive(address indexed receiver, address indexed from, uint8 level);
    event CreatNode(address indexed user, address indexed referrer, uint indexed level);

    mapping(address => User) public users;
    mapping(uint => address) public idToAddress;
    mapping(uint => address) public userIds;
    mapping(address => uint) public balances;
    mapping(address => uint256) public allowancesAmount;
    mapping(address => uint256) public allowanceBalance;
    mapping(uint8 => uint8) public levelPrice;

    address public owner;
    uint public lastUserId = 2;
    AggregatorV3Interface internal priceFeed;

    constructor(address ownerAddress) public {
        priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);  /*Kovan Testnet Feed Price Address */
        levelPrice[0] = 0.05 ether;
        levelPrice[1] = 0.1 ether;
        levelPrice[2] = 0.5 ether;
        for (uint8 i = 3; i <= LAST_LEVEL; i++) {
            levelPrice[i] = levelPrice[i-1] * 2;
        }
        
        owner = ownerAddress;      
    }

    function getLatestPrice() public view returns (int) {
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return price;
    }

    function _generateRandDna(uint memory _id) /** 通过用户id和block.timestamp生成随机数 */
        private
        view
        returns (uint256)
    {
        return
            uint256(keccak256(abi.encodePacked(_id, block.timestamp))) %
            dnaModules;
    }

    function() external payable {
        if(msg.data.length == 0) {
            return registration(msg.sender, owner);
        }
        
        registration(msg.sender, bytesToAddress(msg.data));
    }

    function EthCalMFS(uint8 _value) private payable return (uint8) {
        uint8 ETHPrice = getLatestPrice();
        MFSAmount = msg.value * ETHPrice * 100 / 2;
        return MFSAmount;
    }

    function bytesToAddress(bytes memory bys) private pure returns (address addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }

    function registrationExt(address referrerAddress) external payable {
        registration(msg.sender, referrerAddress);
    }

    function registration(address userAddress, address referrerAddress) private {
        require(msg.value >= 0.5 ether, "registration cost 0.05");
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
            ordertime: block.timestamp.
            calvalue: msg.value,
            nftAmount++
        });
        
        users[userAddress] = user;
        (users[userAdress].totalMFSAmount, users[userAddress].allowance) = _allowances(userAddress, lastUserId);
        idToAddress[lastUserId] = userAddress;
        
        users[userAddress].referrer = referrerAddress;
        users[userAddress].share[1].currentReferrer = referrerAddress;
        userIds[lastUserId] = userAddress;
        lastUserId++;   
        users[referrerAddress].partnersCount++;  
        sendShareMFSDividends(userAddress);
        emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id, users.registime);
    }

    function _allowances(address userAddress, uint _id) private view returns (uint256, uint256) {
        uint256 randDna =  _generateRandDna(_id);
        if (randDna < 2) {
            randDna = 5;
        }

        int price = getLatestPrice();
        uint256 totalValue = users[userAddress].calvalue;
        uint256 TotalMFSAmount = price * totalValue * 100 / 2;
        uint256 allowance = TotalMFSAmount * randDna;
        return TotalMFSAmount, allowance;
    }
    function buyNewNft(address userAddress) external payable {
        require(isUserExists(userAddress), "user is not exists. Register first.");
        require(msg.value >= 0.05 ether, "invalid price");
        users[userAddress].recalvalue += (block.timestamp - users[userAddress].ordertime) / 86400 * user[userAddress].totalMFSAmount / 100;
        users[userAddress].ordertime = block.timestamp;
        users[userAddress].calvalue += msg.sender;
        (users[userAdress].totalMFSAmount, users[userAddress].allowance) = _allowances(userAddress, lastUserId);
        users[userAddress].nftAmount++;
        
        emit BuyNewNft(userAddress, nftAmount, allowance);
        users[userAddress].reinvestCount++;
    }

    function createNode(address userAddress, uint8 level) external payable {
        require(isUserExists(userAddress), "user is not exists. Register first.");       
        require((users[userAddress].calvalue + msg.value) == levelPrice[level], "invalid price");
        require(level >= 1 && level <= LAST_LEVEL, "invalid level");
        require(!users[userAddress].shareLevels[level], "level already activated");

        if (level == 1) {
            require(users[userAddress].partnersCount >= 5, "invalid referrals amount");
            require(users[userAddress].Team[1].TeamTotalValue >= 50 ether, "invalid team total value");
            users[userAddress].NodeLevels[level] = true;
            users[users[userAddress].referrer].Team[1].beginnerNodeReferrals.push();
           
            emit Upgrade(userAddress, level);

        }   else if (level == 2) {
            require(users[userAddress].Team[1].beginnerNodeReferrals.length >= 2, "invalid referrals node amount");
            users[userAddress].NodeLevels[level] = true;
            users[users[userAddress].referrer].Team[1].middleNodeReferrals.push();

            emit Upgrade(userAddress, level);
        }   else if (level == 3) {
            require(users[userAddress].Team[1].middleNodeReferrals >= 2, "invalid referrals node amount");
            users[userAddress].NodeLevels[level] = true;
            users[users[userAddress].referrer].Team[1].advanceNodeReferrals.push();

            emit Upgrade(userAddress, level);
        }  else if (level == 4) {
            require(users[userAddress].Team[1].advanceNodeReferrals.length >= 2, "invalid referrals node amount");
            users[userAddress].NodeLevels[level] = true;

            emit Upgrade(userAddress, level);
        }

        users[userAddress].level = level;
        address freeNodeReferrer = findFreeNodeReferrer(userAddress, level);
        users[userAddress].Team[1].currentReferrer = freeNodeReferrer;
        users[userAddress].Team[1].reinvestCount++;
        sendNodeMFSDividends(address freeNodeReferrer, address userAddress, uint8 level);
        sendShareMFSDividends(address userAddress);

        CreatNode(address indexed userAddress, address indexed freeNodeReferrer, uint indexed level);
    }

    function isUserExists(address user) public view returns (bool) {
        return (users[user].id != 0);
    }

    function findFreeNodeReferrer(address userAddress, uint8 level) public view returns(address) {

            if (users[userAddress].level == 4 && users[users[userAddress].referrer].level == 4) {
                return users[userAddress].referrer;
            } else if (users[userAddress].level == 4 && users[users[userAddress].referrer].level < 4) {
                users[userAddress].Team[1].currentReferrer = address(0);
                return users[userAddress].Team[1].currentReferrer;
            }
        while (true) {
            if (users[userAddress].level < 4 && users[users[userAddress].referrer].level > users[userAddress].level) {
                users[userAddress].Team[1].currentReferrer = users[userAddress].referrer;
                return users[userAddress].Team[1].currentReferrer;
            } else {
                emit MissedMFSReceive(users[userAddress].referrer, userAddress, level);
            }           
            userAddress = users[userAddress].referrer;
        }
    }

    function sendNodeMFSDividends(address recieveAddress, address _from, uint8 _level) private payable {
        recieveAddress = findFreeNodeReferrer(_from, _level);
        uint256 sendMFSAmount = EthCalMFS(msg.sender);
        if (users[recieveAddress].Team[1].level = 2) {
            awardValue[recieveAddress] += sendMFSAmount * 8 / 100;
            address nextRecieveAddress = findFreeNodeReferrer(recieveAddress, users[recieveAddress].Team[1].level);
            if (users[nextRecieveAddress].Team[1].level = 3) {
                awardValue[nextRecieveAddress] += sendMFSAmount * 3 / 100;
                address nextRecieveAddress = findFreeNodeReferrer(nextRecieveAddress, users[nextRecieveAddress].Team[1].level);
                if (users[nextRecieveAddress].Team[1].level = 4) {
                    awardValue[nextRecieveAddress] += sendMFSAmount * 4 / 100;
                    address nextRecieveAddress = findFreeNodeReferrer(nextRecieveAddress, users[nextRecieveAddress].Team[1].level);
                    if (users[nextRecieveAddress].Team[1].level = 4) {
                        awardValue[nextRecieveAddress] += sendMFSAmount * 40 / 10000s;
                    }
                }
            }
        } else if (users[recieveAddress].Team[1].level = 3) {
            awardValue[recieveAddress] += sendMFSAmount * 11 / 100;
            address nextRecieveAddress = findFreeNodeReferrer(recieveAddress, users[recieveAddress].Team[1].level);
            if (users[nextRecieveAddress].Team[1].level = 4) {
                awardValue[nextRecieveAddress] += sendMFSAmount * 4 / 100;
                address nextRecieveAddress = findFreeNodeReferrer(nextRecieveAddress, users[nextRecieveAddress].Team[1].level);
                if (users[nextRecieveAddress].Team[1].level = 4) {
                        awardValue[nextRecieveAddress] += sendMFSAmount * 40 / 10000s;
                    }
        } else if (users[recieveAddress].Team[1].level = 4) {
            awardValue[recieveAddress] += sendMFSAmount * 15 / 100;
            address nextRecieveAddress = findFreeNodeReferrer(nextRecieveAddress, users[nextRecieveAddress].Team[1].level);
            if (users[nextRecieveAddress].Team[1].level = 4) {
                        awardValue[nextRecieveAddress] += sendMFSAmount * 40 / 10000;
                    }
        }
    } 

    function sendShareMFSDividends(address userAddress) private {
        
        uint8 count = 1;

        while (true) {
            if (users[users[userAddress].referrer].id) {

                if (users[users[userAddress].referrer].partnersCount >= count && count == 1) {
                    if (users[users[userAddress].referrer].Team[1].level == 1 && count <= 20) {
                        users[users[userAddress].referrer].Team[1].teamTotalValue += users[userAddress].calvalue;
                    }
                    users[users[userAddress].referrer].Team[1].teamTotalValue += users[userAddress].calvalue;
                    require(users[users[userAddress].referrer].totalMFSAmountBalance > 0, "allowace balance insufficient");
                    if (users[users[userAddress].referrer].totalMFSAmountBalance > (users[userAddress].totalMFSAmount * 15 / 100)) {
                        // users[userAddress].referrer.transfer(users[userAddress].totalMFSAmount * 15 / 100);
                        awardValue[users[userAddress].referrer] += users[userAddress].totalMFSAmount * 15 / 100;
                        users[userAddress].referrer.totalMFSAmountBalance -= users[userAddress].totalMFSAmount * 15 / 100
                    } else {
                        // users[userAddress].referrer.transfer(users[userAddress].referrer.totalMFSAmountBalance);
                        awardValue[users[userAddress].referrer] += users[userAddress].referrer.totalMFSAmountBalance;
                    }
                } else if (users[users[userAddress].referrer].partnersCount >= count && count == 2) {
                    if (users[users[userAddress].referrer].Team[1].level == 1 && count <= 20) {
                        users[users[userAddress].referrer].Team[1].teamTotalValue += users[userAddress].calvalue;
                    }
                    require(users[users[userAddress].referrer].totalMFSAmountBalance > 0, "allowace balance insufficient");
                    if (users[users[userAddress].referrer].totalMFSAmountBalance > (users[userAddress].totalMFSAmount * 15 / 100)) {
                        // users[userAddress].referrer.transfer(users[userAddress].totalMFSAmount * 10 / 100);
                        awardValue[users[userAddress].referrer] += users[userAddress].totalMFSAmount * 10 / 100;
                        users[userAddress].referrer.totalMFSAmountBalance -= users[userAddress].totalMFSAmount * 10 / 100
                    } else {
                        // users[userAddress].referrer.transfer(users[userAddress].referrer.totalMFSAmountBalance);
                        awardValue[users[userAddress].referrer] += users[userAddress].referrer.totalMFSAmountBalance;
                    }
                } else if (users[users[userAddress].referrer].partnersCount >= count && count >= 3 && count <= 5) {
                    if (users[users[userAddress].referrer].Team[1].level == 1 && count <= 20) {
                        users[users[userAddress].referrer].Team[1].teamTotalValue += users[userAddress].calvalue;
                    }
                    require(users[users[userAddress].referrer].totalMFSAmountBalance > 0, "allowace balance insufficient");
                    if (users[users[userAddress].referrer].totalMFSAmountBalance > (users[userAddress].totalMFSAmount * 15 / 100)) {
                        // users[userAddress].referrer.transfer(users[userAddress].totalMFSAmount * 5 / 100);
                        awardValue[users[userAddress].referrer] += users[userAddress].totalMFSAmount * 5 / 100;
                        users[userAddress].referrer.totalMFSAmountBalance -= users[userAddress].totalMFSAmount * 5 / 100
                    } else {
                        // users[userAddress].referrer.transfer(users[userAddress].referrer.totalMFSAmountBalance);
                        awardValue[users[userAddress].referrer] += users[userAddress].referrer.totalMFSAmountBalance;
                    }
                } else if (users[users[userAddress].referrer].partnersCount >= count && count >= 6 && count <= 10) {
                    if (users[users[userAddress].referrer].Team[1].level == 1 && count <= 20) {
                        users[users[userAddress].referrer].Team[1].teamTotalValue += users[userAddress].calvalue;
                    }
                    require(users[users[userAddress].referrer].totalMFSAmountBalance > 0, "allowace balance insufficient");
                    if (users[users[userAddress].referrer].totalMFSAmountBalance > (users[userAddress].totalMFSAmount * 15 / 100)) {
                        // users[userAddress].referrer.transfer(users[userAddress].totalMFSAmount * 2 / 100);
                        awardValue[users[userAddress].referrer] += users[userAddress].totalMFSAmount * 2 / 100;
                        users[userAddress].referrer.totalMFSAmountBalance -= users[userAddress].totalMFSAmount * 2 / 100
                    } else {
                        // users[userAddress].referrer.transfer(users[userAddress].referrer.totalMFSAmountBalance);
                        awardValue[users[userAddress].referrer] += users[userAddress].referrer.totalMFSAmountBalance;
                    }
                } else if (users[users[userAddress].referrer].Team[1].level == 1 && count <= 20) {
                    users[users[userAddress].referrer].Team[1].teamTotalValue += users[userAddress].calvalue;
            } else {
                return;
            }

                userAddress = users[userAddress].referrer;
                count++;
                    }
                }
    }
    }
}