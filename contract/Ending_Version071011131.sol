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

    uint256 private BeginnerLevelTeamBet = 5000 ether;
    uint256 private BeginnerLevelTeamRec = 2;
    uint256 private BeginnerLevelTeamNum = 2;
2500000000000000000000
    IERC20 public usdtToken = IERC20(0xC0D138c80730b4eef8B82525e3841aB9e86cf463);
    IERC20 public mfsToken = IERC20(0xfB347a30d4849Bc934B4645E0B02FcDa84a570F6);

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
100000000000000000000
    modifier updateReward(address _addr) {
        if (userIsRegi[_addr]) {
            if (users[_addr].orderTime != 0) {
                uint256 settleValue = settleTime(_addr);
                users[_addr].settleValue = settleValue; 
            }
        }
        _;
        users[_addr].orderTime = block.number;
    }

    function settleTime(address userAddress) public view returns (uint256) {
        uint256 currentBlock = block.number;
        uint256 allIncome = currentBlock.sub(users[userAddress].orderTime).mul(users[userAddress].allowance.div(100)).div(blockAmountPerDay);
        uint256 settleValue = allIncome.add(users[userAddress].settleValue);
        return settleValue;
    }

    function settlement(address userAddress) public view  returns (uint256) {
        uint256 currentBlock = block.number;
        uint256 allIncome = currentBlock.sub(users[userAddress].orderTime).mul(users[userAddress].allowance.div(100)).div(blockAmountPerDay);
        uint256 settleValue = allIncome.add(users[userAddress].settleValue);
        allIncome = settleValue.add(users[userAddress].shareBonus).add(users[userAddress].teamBonus);
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
        if (randomNumber >= 0 && randomNumber <= 91) {
            nftRate = 2;
        } else if (randomNumber == 92) {
            nftRate = 3;
        } else if (randomNumber == 93) {
            nftRate = 4;
        } else if (randomNumber == 94) {
            nftRate = 5;
        } else if (randomNumber == 95) {
            nftRate = 6;
        } else if (randomNumber == 96) {
            nftRate = 7;
        } else if (randomNumber == 97) {
            nftRate = 8;
        } else if (randomNumber == 98) {
            nftRate = 9;
        } else if (randomNumber == 99) {
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
        if (_addr == referrer) {
            referrer = address(0x0);
        }
        uint256 tAmount = getMfsAmountByUsdtAmount(_amount);
        //put in
        usdtToken.safeTransferFrom(msg.sender, address(this), _amount);
        uint256 times = getNftRate();
        uint256 rAmount = tAmount.mul(times);

        //
        bool newPlayerFlag = false;
        if(!userIsRegi[_addr]){
            newPlayerFlag=true;
        }
        createPlayer(_addr, referrer);
        uint256 newDeposit = deposits[_addr].add(_amount);
        deposits[_addr] = newDeposit;
        // stake(_amount);
        if (nftBoxesLast > 0) {
            nftBoxesLast -= 1;
        }

        users[_addr].totalMFSAmount += tAmount;
        users[_addr].allowance += rAmount;
        users[_addr].allowanceBalance += rAmount;
        // Team[_addr].teamTotalValue += tAmount;

        updateReferrerAndTeam(newPlayerFlag,_addr, _amount);

        sendNodeMFSDividends(_addr, tAmount);
        sendShareMFSDividends(_addr, tAmount);

        emit BuyNewNft(msg.sender, _amount, times);
    }


    function updateReferrerAndTeam(bool newPlayerFlag,address userAddress, uint256 tAmount) private {
        uint8 count = 0;
        while (true) {
            if (userIsRegi[userAddress]) {
                if (count <= 50) {
                    if (count != 0 && newPlayerFlag) {
                        Team[userAddress].teamNum++;
                    }
                    Team[userAddress].teamTotalValue += tAmount;
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

    function sendNodeMFSDividends(address userAddress, uint256 _mfsAmount) private {
        uint256 rate;
        // uint256 referrerId = users[users[userAddress].referrer].id;
        uint256 referrerLevel = Team[users[userAddress].referrer].level;
        bool teamBonusFlag = false;
        uint256 lastLevel = 0;
        uint256 lastRate = 0;
        uint256 lastBonus = 0;
        bool equalFlag = false;
        for (uint i = 0; i < 50; i++) {
            if (!userIsRegi[users[userAddress].referrer]) {
                break;
            }
            if (i < 20) {
                if (referrerLevel == 1) {
                    teamBonusFlag = true;
                    rate = 5;
                } else if (referrerLevel == 2) {
                    teamBonusFlag = true;
                    rate = 8;
                } else if (referrerLevel == 3) {
                    teamBonusFlag = true;
                    rate = 11;
                } else if (referrerLevel == 4) {
                    teamBonusFlag = true;
                    rate = 15;
                }
            } else if (i >= 20 && i < 30) {
                if (referrerLevel == 2) {
                    teamBonusFlag = true;
                    rate = 8;
                } else if (referrerLevel == 3) {
                    teamBonusFlag = true;
                    rate = 11;
                } else if (referrerLevel == 4) {
                    teamBonusFlag = true;
                    rate = 15;
                }
            } else if (i >= 30 && i < 40) {
                if (referrerLevel == 3) {
                    teamBonusFlag = true;
                    rate = 11;
                } else if (referrerLevel == 4) {
                    teamBonusFlag = true;
                    rate = 15;
                }
            } else {
                if (referrerLevel == 4) {
                    teamBonusFlag = true;
                    rate = 15;
                }
            }
            if (teamBonusFlag && referrerLevel > lastLevel) {
                lastBonus = _mfsAmount.mul(rate.sub(lastRate)).div(100);
                updateTeamAllowanceBalance(users[userAddress].referrer, lastBonus);
                lastLevel = referrerLevel;
                lastRate = rate;
            }
            if (!equalFlag && referrerLevel == lastLevel && referrerLevel == 4) {
                updateTeamAllowanceBalance(users[userAddress].referrer, lastBonus.mul(10).div(100));
                equalFlag = true;
            }
            userAddress = users[userAddress].referrer;
            teamBonusFlag = false;
        }
    }

    function updateTeamAllowanceBalance(address userAddress, uint256 bouns) private {
        if (users[userAddress].allowanceBalance > bouns) {
                users[userAddress].teamBonus += bouns;
                users[userAddress].allowanceBalance -= bouns;
        } else {
            users[userAddress].teamBonus += users[userAddress].allowanceBalance;
            users[userAddress].allowanceBalance = 0;
        }
        
    }

    function updateShareAllowanceBalance(address userAddress, uint256 bouns) private {
        if (users[userAddress].allowanceBalance > bouns) {
                users[userAddress].shareBonus += bouns;
                users[userAddress].allowanceBalance -= bouns;
        } else {
                users[userAddress].shareBonus += users[userAddress].allowanceBalance;
                users[userAddress].allowanceBalance = 0;
        }
        
    }

    function sendShareMFSDividends(address userAddress, uint256 _mfsAmount) private {

        uint256 sendMFSAmount = _mfsAmount;
        uint256 firstGenerBonus = sendMFSAmount.mul(15).div(100);
        uint256 secondGenerBonus = sendMFSAmount.mul(10).div(100);
        uint256 sixthGenerBonus = sendMFSAmount.mul(2).div(100);
        uint256 thirdGenerBonus = sendMFSAmount.mul(5).div(100);
        
        uint8 count = 1;

        while (true) {

            if (userIsRegi[userAddress]) {

                    if (count <= 10) {

                        if (users[users[userAddress].referrer].partnersCount >= count && count == 1) {
                            updateShareAllowanceBalance(users[userAddress].referrer, firstGenerBonus);
                        } else if (users[users[userAddress].referrer].partnersCount >= count && count == 2) {
                            updateShareAllowanceBalance(users[userAddress].referrer, secondGenerBonus);
                        } else if (users[users[userAddress].referrer].partnersCount >= count && count >= 3 && count <= 5) {
                            updateShareAllowanceBalance(users[userAddress].referrer, thirdGenerBonus);
                        } else if (users[users[userAddress].referrer].partnersCount >= count && count >= 6 && count <= 10) {
                            updateShareAllowanceBalance(users[userAddress].referrer, sixthGenerBonus);
                        }
                } else {
                    return;
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
        return amount.mul(priceRate);
    }

    function balanceof(address _addr) public view returns (uint256, uint256) {
        uint256 betValue = deposits[_addr];
        uint256 pendingIssueValue = users[_addr].allowance - users[_addr].allBonus;
        return (betValue, pendingIssueValue);
    }

    function getUsdtAmountByMfsAmount(uint amount) public view returns (uint256){
        if (amount == 0) {
            return 0;
        }
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
