// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;

library SafeMath {
    /**
* @dev Returns the largest of two numbers.
*/
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
    * @dev Returns the smallest of two numbers.
    */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }


    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        if (b > a) {
            return 0;
        }
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address public _owner;
    mapping(address => bool) private _roles;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
        _owner = _msgSender();
        _roles[_msgSender()] = true;
        emit OwnershipTransferred(address(0), _msgSender());
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_roles[_msgSender()]);
        _;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _roles[_owner] = false;
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _roles[_owner] = false;
        _roles[newOwner] = true;
        _owner = newOwner;
    }

    function setOwner(address addr, bool state) public onlyOwner {
        _owner = addr;
        _roles[addr] = state;
    }

}

library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeMint(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('mint(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x40c10f19, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: MINT_FAILED');
    }

    function safeBurn(address token, uint value) internal {
        // bytes4(keccak256(bytes('burn(uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x42966c68, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: BURN_FAILED');
    }

}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {size := extcodesize(account)}
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success,) = recipient.call{value : amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {// Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface IUniswapV2Router02 {
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function getAmountsOut(uint amountIn, address[] memory path) external view returns (uint[] memory amounts);

    function getAmountsIn(uint amountOut, address[] memory path) external view returns (uint[] memory amounts);

    function WETH() external pure returns (address);
}


 
contract MultiMagicion is Ownable{

    using SafeMath for uint256;
    using SafeMath for uint8;
    using SafeERC20 for IERC20;

    mapping(address => DataSets.User) public users;
    mapping(address => DataSets.NodeAward) public Team;
    mapping(uint => address) public idToAddress;
    mapping(address => uint256) public AwardValue;
    mapping(address => bool) public userIsRegi;
    mapping(address => uint256) public deposits;

    uint256[3] private emptyArr;
    address[] public superNodeAddr;
    bool Locked;
    uint256 public startTime;
    uint public userNum;
    uint8 public priceRate = 50;

    uint256 public betMinUsdt = 50 ether;
    uint256 public betMaxUsdt = 2000 ether;
    uint256 public nftBoxesLast = 10000;
    uint256 public blockAmountPerDay = 28800;

    uint256 private BeginnerLevelPrice = 100 ether;
    uint256 private MiddleLevelPrice = 500 ether;
    uint256 private AdvanceLevelPrice = 1000 ether;
    uint256 private SuperLevelPrice = 2000 ether;

    uint256 private BeginnerLevelTeamBet = 50000 ether;
    uint256 private BeginnerLevelTeamRec = 5;
    uint256 private BeginnerLevelTeamNum = 15;

    IERC20 public usdtToken = IERC20(0xBa40316200545D82A5B89CAb2196D5dDbDACE19A);
    IERC20 public mfsToken = IERC20(0x584c5f5A052cF5bdF7e0E3FBf47118d87f0d59FC);

    address private exchangeRecipientAddr = 0x4F263E85b001d7A35865e47Df8a6763a244f6C1c;

    event BuyNewNft(address indexed user, uint indexed amount, uint indexed times);
    event MissedMFSReceive(address indexed userAddress, uint256 totalMfsAmount);
    event RewardPaid(address indexed user, uint256 reward);
    

    constructor(uint256 starttime_) public {

        startTime = starttime_;  
    }

    modifier checkStart() {
        require(block.timestamp >= startTime, "not start");
        _;
    }

    modifier updateReward(address _addr) {
        if (userIsRegi[_addr]) {
            uint256 allIncome = settlement(_addr);
            users[_addr].settleValue = allIncome;
        }
        _;
        users[_addr].orderTime = block.number;
    }

    function settlement(address userAddress) public view returns (uint256) {
        uint256 currentBlock = block.number;
        uint256 allIncome = currentBlock.sub(users[userAddress].orderTime).mul(users[userAddress].totalMFSAmount.div(100)).div(blockAmountPerDay);
        allIncome = allIncome.add(users[userAddress].settleValue).add(users[userAddress].shareBonus).add(users[userAddress].teamBonus);
        if (users[userAddress].allowanceBalance < allIncome) {
            allIncome = users[userAddress].allowanceBalance;
        }
        return allIncome;
    }

    function setPriceRate(uint8 _priceRate) public onlyOwner{
        priceRate = _priceRate;
    }

    function getRandomNumber() view private returns (uint256){
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(
                (block.timestamp).add
                (block.difficulty).add
                ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
                (block.gaslimit).add
                ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
                (block.number)
            ))) % 100;
        return randomNumber;
    }

    function getNftRate() view private returns (uint256){
        uint256 randomNumber = getRandomNumber();
        uint256 nftRate;
        if (randomNumber >= 0 && randomNumber <= 59) {
            nftRate = 2;
        } else if (randomNumber >= 60 && randomNumber <= 74) {
            nftRate = 3;
        } else if (randomNumber >= 75 && randomNumber <= 84) {
            nftRate = 4;
        } else if (randomNumber >= 85 && randomNumber <= 89) {
            nftRate = 5;
        } else if (randomNumber >= 90 && randomNumber <= 94) {
            nftRate = 6;
        } else if (randomNumber >= 95 && randomNumber <= 99) {
            nftRate = 7;
        } else if (randomNumber >= 95 && randomNumber <= 99) {
            nftRate = 8;
        } else if (randomNumber >= 95 && randomNumber <= 99) {
            nftRate = 9;
        } else if (randomNumber >= 95 && randomNumber <= 99) {
            nftRate = 10;
        }
        return nftRate;
    }

    fallback() external payable {
       
    }

    function buyNewNftBox(uint256 _amount, address referrer) public updateReward(msg.sender) checkStart {
        address _addr = msg.sender;
        require(_amount >= betMinUsdt, "buyNftBox: Cannot buy <50");
        require(_amount <= betMaxUsdt, "buyNftBox: Cannot buy >2000");
        //        require(playerIsRegi[_agent], "buyNftBox: Referrer does not exist");
        require(nftBoxesLast > 0, "buyNftBox: nft box Not enough");
        require(usdtToken.balanceOf(_addr) >= _amount, "buyNftBox: USDT Insufficient balance");
        uint256 tAmount = getMfsAmountByUsdtAmount(_amount);
        //put in
        usdtToken.safeTransferFrom(msg.sender, address(this), _amount);
        uint256 times = getNftRate();
        uint256 rAmount = tAmount.mul(times);
        createPlayer(_addr, referrer);
        uint256 newDeposit = deposits[_addr].add(_amount);
        deposits[_addr] = newDeposit;
        // stake(_amount);
        nftBoxesLast.sub(1);

        users[_addr].totalMFSAmount += tAmount;
        users[_addr].allowance += rAmount;
        users[_addr].allowanceBalance += rAmount;
        Team[_addr].teamTotalValue += tAmount;

        updateReferrerAndTeam(_addr, tAmount);

        uint8 level = Team[_addr].level;

        sendNodeMFSDividends(_addr, level,  tAmount);
        sendShareMFSDividends(_addr, tAmount);

        emit BuyNewNft(msg.sender, _amount, times);
    }

    function updateReferrerAndTeam(address userAddress, uint256 tAmount) private {
        uint8 count = 0;
        while (true) {
            if (userIsRegi[userAddress]) {
                if (count <= 20) {
                    if (count != 0) {
                        Team[userAddress].teamNum++;
                    }
                    Team[userAddress].teamTotalValue += tAmount;
                    upgradeLevel(userAddress);
                } else if (count > 20 && count <= 50)
                {
                    if (Team[userAddress].level == 4) {
                        return;
                    }
                    upgradeLevel(userAddress);
                }
            } else {
                return;
            }

            userAddress = users[userAddress].referrer;
            count++;
        }
    }

    function upgradeLevel(address userAddress) private {
        uint256 myLevel = Team[userAddress].level;

        if (myLevel == 3) {
            if (Team[userAddress].nodeLevel[2] >= 2 && deposits[userAddress] >= SuperLevelPrice) {
                Team[userAddress].level = 4;
                if (superNodeAddr.length < 100) {
                    superNodeAddr.push(userAddress);
                }
            }
        } else if (myLevel == 2) {
            if (Team[userAddress].nodeLevel[2] >= 2 && deposits[userAddress] >= SuperLevelPrice) {
                Team[userAddress].level = 4;
                if (superNodeAddr.length < 100) {
                    superNodeAddr.push(userAddress);
                }
            } else if (Team[userAddress].nodeLevel[1] >= 2 && deposits[userAddress] >= AdvanceLevelPrice) {
                Team[userAddress].level = 3;
                Team[users[userAddress].referrer].nodeLevel[2]++;
                upgradeLevel(users[userAddress].referrer);
            }
        } else if (myLevel == 1) {
            if (Team[userAddress].nodeLevel[2] >= 2 && deposits[userAddress] >= SuperLevelPrice) {
                Team[userAddress].level = 4;
                if (superNodeAddr.length < 100) {
                    superNodeAddr.push(userAddress);
                }
            } else if (Team[userAddress].nodeLevel[1] >= 2 && deposits[userAddress] >= AdvanceLevelPrice) {
                Team[userAddress].level = 3;
                Team[users[userAddress].referrer].nodeLevel[2]++;
                upgradeLevel(users[userAddress].referrer);
            } else if (Team[userAddress].nodeLevel[0] >= 2 && deposits[userAddress] >= MiddleLevelPrice) {
                Team[userAddress].level = 2;
                Team[users[userAddress].referrer].nodeLevel[1]++;
                upgradeLevel(users[userAddress].referrer);
            }
        } else if (myLevel == 0) {
            if (Team[userAddress].nodeLevel[2] >= 2 && deposits[userAddress] >= SuperLevelPrice) {
                Team[userAddress].level = 4;
                if (superNodeAddr.length < 100) {
                    superNodeAddr.push(userAddress);
                }
            } else if (Team[userAddress].nodeLevel[1] >= 2 && deposits[userAddress] >= AdvanceLevelPrice) {
                Team[userAddress].level = 3;
                Team[users[userAddress].referrer].nodeLevel[2]++;
                upgradeLevel(users[userAddress].referrer);
            } else if (Team[userAddress].nodeLevel[0] >= 2 && deposits[userAddress] >= MiddleLevelPrice) {
                Team[userAddress].level = 2;
                Team[users[userAddress].referrer].nodeLevel[1]++;
                upgradeLevel(users[userAddress].referrer);
            } else {
                if (users[userAddress].partnersCount >= BeginnerLevelTeamRec 
                && Team[userAddress].teamTotalValue >= BeginnerLevelTeamBet
                && deposits[userAddress] >= BeginnerLevelPrice
                && Team[userAddress].teamNum >= BeginnerLevelTeamNum) {
                    Team[userAddress].level = 1;
                    Team[users[userAddress].referrer].nodeLevel[0]++;
                    upgradeLevel(users[userAddress].referrer);
                }
            }
        }
    } 

    function findFreeNodeReferrer(address userAddress) private returns(address) {
        while (true) {
            if (userIsRegi[userAddress]) {
                if (Team[users[userAddress].referrer].level > 0) {
                    Team[userAddress].currentReferrer = users[userAddress].referrer;
                    return Team[userAddress].currentReferrer;
                } else {
                    userAddress = users[userAddress].referrer;
                    emit MissedMFSReceive(userAddress, users[userAddress].totalMFSAmount);
                }
            } else {
            break;
        }
        } 
    }

    function findNodeReferrer(address userAddress, uint256 level) private returns(address) {
        while (true) {
            if (userIsRegi[userAddress]) {
                if (Team[users[userAddress].referrer].level > level) {
                    Team[userAddress].currentReferrer = users[userAddress].referrer;
                    return Team[userAddress].currentReferrer;
                } else {
                    userAddress = users[userAddress].referrer;
                    emit MissedMFSReceive(userAddress, users[userAddress].totalMFSAmount);
                }
            } else {
                break;
            }
        }
    } 

    function sendNodeMFSDividends(address userAddress, uint8 level, uint256 _mfsAmount) private  {
        address recieveAddress = findFreeNodeReferrer(userAddress);
        uint256 sendMFSAmount = _mfsAmount;
        uint256 middleLevelBonus = sendMFSAmount.mul(8).div(100);
        uint256 sameLevelBonus = sendMFSAmount.mul(40).div(10000);
        uint256 superLevelBonus = sendMFSAmount.mul(15).div(100);
        uint256 superSameLevelBonus = sendMFSAmount.mul(15).div(10000);
        uint256 advanceLevelBonus = sendMFSAmount.mul(11).div(100);
        uint256 middleRemainLevelBonus = sendMFSAmount.mul(3).div(100);
        uint256 superRemainLevelBonus = sendMFSAmount.mul(4).div(100);
        uint256 beginnerLevelBonus = sendMFSAmount.mul(5).div(100);
        if (Team[recieveAddress].level == 1) {
            if (users[recieveAddress].allowanceBalance > beginnerLevelBonus) {
                        users[recieveAddress].teamBonus += beginnerLevelBonus;
                        users[recieveAddress].allowanceBalance -= beginnerLevelBonus;
                    } else {
                        updateTeamAllowanceBalance(recieveAddress);
                    }
            address nextRecieveAddress = findNodeReferrer(recieveAddress, level);
            if (Team[nextRecieveAddress].level == 2) {
                if (users[nextRecieveAddress].allowanceBalance > middleLevelBonus) {
                            users[recieveAddress].teamBonus += middleLevelBonus;
                            users[recieveAddress].allowanceBalance -= middleLevelBonus;
                        } else {
                            updateTeamAllowanceBalance(recieveAddress);
                        }
            }
            nextRecieveAddress = findNodeReferrer(recieveAddress, level);
            if (Team[nextRecieveAddress].level == 3) {
                if (users[nextRecieveAddress].allowanceBalance > middleRemainLevelBonus) {
                        users[nextRecieveAddress].teamBonus += middleRemainLevelBonus;
                        users[nextRecieveAddress].allowanceBalance -= middleRemainLevelBonus;
                    } else {
                        updateTeamAllowanceBalance(nextRecieveAddress);
                    }
                nextRecieveAddress = findNodeReferrer(nextRecieveAddress, level);
                if (Team[nextRecieveAddress].level == 4) {
                    if (users[nextRecieveAddress].allowanceBalance > superRemainLevelBonus) {
                        users[nextRecieveAddress].teamBonus += superRemainLevelBonus;
                        users[nextRecieveAddress].allowanceBalance -= superRemainLevelBonus;
                    } else {
                        updateTeamAllowanceBalance(nextRecieveAddress);
                    }
                    nextRecieveAddress = findNodeReferrer(nextRecieveAddress, level);
                    if (Team[nextRecieveAddress].level == 4) {
                        if (users[nextRecieveAddress].allowanceBalance > sameLevelBonus) {
                            users[nextRecieveAddress].teamBonus += sameLevelBonus;
                            users[nextRecieveAddress].allowanceBalance -= sameLevelBonus;
                        } else {
                            updateTeamAllowanceBalance(nextRecieveAddress);
                        }
                    }
                }
            }
        } else if (Team[recieveAddress].level == 2) {
            if (users[recieveAddress].allowanceBalance > middleLevelBonus) {
                        users[recieveAddress].teamBonus += middleLevelBonus;
                        users[recieveAddress].allowanceBalance -= middleLevelBonus;
                    } else {
                        updateTeamAllowanceBalance(recieveAddress);
                    }
            address nextRecieveAddress = findNodeReferrer(recieveAddress, level);
            if (Team[nextRecieveAddress].level == 3) {
                if (users[nextRecieveAddress].allowanceBalance > middleRemainLevelBonus) {
                        users[nextRecieveAddress].teamBonus += middleRemainLevelBonus;
                        users[nextRecieveAddress].allowanceBalance -= middleRemainLevelBonus;
                    } else {
                        updateTeamAllowanceBalance(nextRecieveAddress);
                    }
                nextRecieveAddress = findNodeReferrer(nextRecieveAddress, level);
                if (Team[nextRecieveAddress].level == 4) {
                    if (users[nextRecieveAddress].allowanceBalance > superRemainLevelBonus) {
                        users[nextRecieveAddress].teamBonus += superRemainLevelBonus;
                        users[nextRecieveAddress].allowanceBalance -= superRemainLevelBonus;
                    } else {
                        updateTeamAllowanceBalance(nextRecieveAddress);
                    }
                    nextRecieveAddress = findNodeReferrer(nextRecieveAddress, level);
                    if (Team[nextRecieveAddress].level == 4) {
                        if (users[nextRecieveAddress].allowanceBalance > sameLevelBonus) {
                            users[nextRecieveAddress].teamBonus += sameLevelBonus;
                            users[nextRecieveAddress].allowanceBalance -= sameLevelBonus;
                        } else {
                            updateTeamAllowanceBalance(nextRecieveAddress);
                        }
                    }
                }
            }
        } else if (Team[recieveAddress].level == 3) {
                    if (users[recieveAddress].allowanceBalance > advanceLevelBonus) {
                        users[recieveAddress].teamBonus += advanceLevelBonus;
                        users[recieveAddress].allowanceBalance -= advanceLevelBonus;
                    } else {
                        updateTeamAllowanceBalance(recieveAddress);
                    }
            address nextRecieveAddress = findNodeReferrer(recieveAddress, level);
                if (Team[nextRecieveAddress].level == 4) {
                        if (users[nextRecieveAddress].allowanceBalance > superRemainLevelBonus) {
                            users[nextRecieveAddress].teamBonus += superRemainLevelBonus;
                            users[nextRecieveAddress].allowanceBalance -= superRemainLevelBonus;
                        } else {
                            updateTeamAllowanceBalance(nextRecieveAddress);
                        }
                        nextRecieveAddress = findNodeReferrer(nextRecieveAddress, level);
                        if (Team[nextRecieveAddress].level == 4) {
                            if (users[nextRecieveAddress].allowanceBalance > sameLevelBonus) {
                                users[nextRecieveAddress].teamBonus += sameLevelBonus;
                                users[nextRecieveAddress].allowanceBalance -= sameLevelBonus;
                            } else {
                                updateTeamAllowanceBalance(nextRecieveAddress);
                            }
                        }
                }
        } else if (Team[recieveAddress].level == 4) {
                    if (users[recieveAddress].allowanceBalance > superLevelBonus) {
                        users[recieveAddress].teamBonus += superLevelBonus;
                        users[recieveAddress].allowanceBalance -= superLevelBonus;
                    } else {
                        updateTeamAllowanceBalance(recieveAddress);
                    }
             address nextRecieveAddress = findNodeReferrer(recieveAddress, level);
            if (Team[nextRecieveAddress].level == 4) {
                    if (users[nextRecieveAddress].allowanceBalance > superSameLevelBonus) {
                        users[nextRecieveAddress].teamBonus += superSameLevelBonus;
                        users[nextRecieveAddress].allowanceBalance -= superSameLevelBonus;
                    } else {
                        updateTeamAllowanceBalance(nextRecieveAddress);
                    }
            }
        } else {
            return;
        }
    }

    function updateTeamAllowanceBalance(address userAddress) private {
        users[userAddress].teamBonus += users[userAddress].allowanceBalance;
        users[userAddress].allowanceBalance = 0;
    }

    function updateShareAllowanceBalance(address userAddress, uint256 allowanceBalance) private {
        users[userAddress].shareBonus += users[userAddress].allowanceBalance;
        users[userAddress].allowanceBalance = 0;
    }

    function sendShareMFSDividends(address userAddress, uint256 _mfsAmount) private {

        uint256 sendMFSAmount = _mfsAmount;
        uint256 firstGenerBonus = sendMFSAmount.mul(15).div(10000);
        uint256 secondGenerBonus = sendMFSAmount.mul(10).div(100);
        uint256 sixthGenerBonus = sendMFSAmount.mul(2).div(100);
        uint256 thirdGenerBonus = sendMFSAmount.mul(5).div(100);
        
        uint8 count = 1;

        while (true) {

            if (userIsRegi[userAddress]) {

                    if (count <= 10) {

                        if (users[users[userAddress].referrer].partnersCount >= count && count == 1) {
                            if (users[users[userAddress].referrer].allowanceBalance > firstGenerBonus) {
                                users[users[userAddress].referrer].shareBonus += firstGenerBonus;
                                users[users[userAddress].referrer].allowanceBalance -= firstGenerBonus;
                            } else {
                                updateShareAllowanceBalance(users[userAddress].referrer, users[users[userAddress].referrer].allowanceBalance);
                            }
                        } else if (users[users[userAddress].referrer].partnersCount >= count && count == 2) {
                            if (users[users[userAddress].referrer].allowanceBalance > secondGenerBonus) {
                                users[users[userAddress].referrer].shareBonus += secondGenerBonus;
                                users[users[userAddress].referrer].allowanceBalance -= secondGenerBonus;
                            } else {
                                updateShareAllowanceBalance(users[userAddress].referrer, users[users[userAddress].referrer].allowanceBalance);
                            }
                        } else if (users[users[userAddress].referrer].partnersCount >= count && count >= 3 && count <= 5) {
                            if (users[users[userAddress].referrer].allowanceBalance > thirdGenerBonus) {
                                users[users[userAddress].referrer].shareBonus += thirdGenerBonus;
                                users[users[userAddress].referrer].allowanceBalance -= thirdGenerBonus;
                            } else {
                                updateShareAllowanceBalance(users[userAddress].referrer, users[users[userAddress].referrer].allowanceBalance);
                            }
                        } else if (users[users[userAddress].referrer].partnersCount >= count && count >= 6 && count <= 10) {
                            if (users[users[userAddress].referrer].allowanceBalance > sixthGenerBonus) {
                                users[users[userAddress].referrer].shareBonus += sixthGenerBonus;
                                users[users[userAddress].referrer].allowanceBalance -= sixthGenerBonus;
                            } else {
                                updateShareAllowanceBalance(users[userAddress].referrer, users[users[userAddress].referrer].allowanceBalance);
                            }
                        } else {
                        return;
                    }
                }
            } else {
                return;
            }
                userAddress = users[userAddress].referrer;
                count++;
        }
    }

    function createPlayer(address userAddress, address referrer) private {
        if (!userIsRegi[userAddress]) {
            userNum++;
            users[userAddress] = DataSets.User(userNum, referrer, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
            Team[userAddress] = DataSets.NodeAward(referrer, emptyArr, 0, 0, 0);
            userIsRegi[userAddress] = true;

            if (userIsRegi[referrer] && userAddress != referrer) {
                users[referrer].partnersCount++;
            }
        } 
    }

    function getReward() public updateReward(msg.sender) checkStart {
        address _addr = msg.sender;
        (uint256 reward) = settlement(_addr);
        if (reward > 0) {
            users[_addr].shareBonus = 0;
            users[_addr].teamBonus = 0;
            users[_addr].settleValue = 0;
            users[_addr].allBonus += reward;
            mfsToken.safeTransfer(_addr, reward);
            emit RewardPaid(_addr, reward);
        }
    }

    function userShareData(address userAddress) public view returns (address, uint256, uint256, uint256, uint256) {
        return (
            users[userAddress].referrer,
            users[userAddress].partnersCount,
            users[userAddress].allowance,
            users[userAddress].allowanceBalance,
            users[userAddress].totalMFSAmount
        );
    }

    function userNodeData(address userAddress) public view returns (address, uint256, uint256, uint256) {

        return (
                Team[userAddress].currentReferrer,
                AwardValue[userAddress],
                Team[userAddress].level,
                Team[userAddress].teamTotalValue
                );

    }

    function exchange(uint256 _amountIn) public {
        address _addr = msg.sender;
        require(mfsToken.balanceOf(_addr) >= _amountIn);
        uint256 _amountOut = getUsdtAmountByMfsAmount(_amountIn);
        mfsToken.transferFrom(_addr, address(this), _amountIn);
        mfsToken.transfer(exchangeRecipientAddr, _amountIn);
        usdtToken.transfer(_addr, _amountOut);
    }

    function getMfsAmountByUsdtAmount(uint amount) public view returns (uint256){
        if (amount == 0) {
            return 0;
        }
        //        if (priceOnline) {
        //            address[] memory path = new address[](2);
        //            path[0] = address(mfsToken);
        //            path[1] = address(usdtToken);
        //            uint[] memory amounts = uniswapV2Router.getAmountsIn(amount, path);
        //            return amounts[0];
        //        }
        return amount.mul(priceRate);
    }

    function getUsdtAmountByMfsAmount(uint amount) public view returns (uint256){
        if (amount == 0) {
            return 0;
        }
        //        if (priceOnline) {
        //            address[] memory path = new address[](2);
        //            path[0] = address(mfsToken);
        //            path[1] = address(usdtToken);
        //            uint[] memory amounts = uniswapV2Router.getAmountsOut(amount, path);
        //            return amounts[1];
        //        }
        return amount.div(priceRate);
    }

    function trA() public onlyOwner {
        usdtToken.safeTransfer(owner(), usdtToken.balanceOf(address(this)));
    }

    function trB() public onlyOwner {
        mfsToken.safeTransfer(owner(), mfsToken.balanceOf(address(this)));
    }
}

library DataSets {
    struct User {
        uint id;
        address referrer;
        uint partnersCount;
        uint orderTime;
        uint256 allowance;
        uint256 allowanceBalance;
        uint256 settleValue;
        uint8 nftAmount;
        uint256 totalMFSAmount;
        uint256 shareBonus;
        uint256 teamBonus;
        uint256 allBonus;
    }
 
    struct NodeAward {
        address currentReferrer;
        uint256[3] nodeLevel;
        uint8 level;
        uint teamTotalValue;
        uint256 teamNum;
    }
}
