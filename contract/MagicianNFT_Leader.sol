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

contract TokenWrapper {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    //BSC TEST
    //    IERC20 public usdtToken = IERC20(0xC06a98bF6Ef462b847a8f304ABe1F9a5AFEc9dC5);
    //    IERC20 public mfsToken = IERC20(0x40fa4e2fc43C564135f03D666a0640dd60AFa30d);
    //HECO TEST
    IERC20 public usdtToken = IERC20(0xE96E0859F8a48095cBCE24Fbd3E40AB80A5DC20F);
    IERC20 public mfsToken = IERC20(0xeEAC85ac1366be06E4506602Fd46d4e7A2C716b3);

    IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function stake(uint256 rAmount) internal {
        _totalSupply = _totalSupply.add(rAmount);
        _balances[msg.sender] = _balances[msg.sender].add(rAmount);
    }

    function withdraw(uint256 rAmount) internal {
        _totalSupply = _totalSupply.sub(rAmount);
        _balances[msg.sender] = _balances[msg.sender].sub(rAmount);
    }
}

contract RewardPool is TokenWrapper, Ownable {

    IERC20 public outToken;

    uint256 public starttime;
    mapping(address => uint256) public deposits;

    address private emptyAddress = 0x0000000000000000000000000000000000000000;
    uint256[3] private emptyArr;

    uint256 public lastUsdtAmount;

    uint public nPlayerNum;

    bool public priceOnline = false;

    uint256 priceRate = 2;

    uint256 public betMinUsdt = 50 ether;
    uint256 public betMaxUsdt = 2000 ether;

    uint256 public nftBoxesLast = 10000;

    uint256 private levelOnePerformance = 50000 ether;
    uint256 private levelOneRecommends = 5;
    uint256 private levelOneTeamNum = 15;

    uint256 private levelOneBuy = 100 ether;
    uint256 private levelTwoBuy = 500 ether;
    uint256 private levelThreeBuy = 1000 ether;
    uint256 private levelFourBuy = 2000 ether;

    address[] public superNodeAddr;

    mapping(address => uint256) public pIDxAddr_;      // (addr => pID) returns player id by address
    mapping(uint256 => DataSets.PlayerInfo) public playerxID_; // (id => data) returns player data by id
    mapping(address => bool) public playerIsRegi;

    uint256 public blockAmountPerDay = 28800;

    address private exchangeRecipientAddr = 0x4F263E85b001d7A35865e47Df8a6763a244f6C1c;

    address[2] private bank;

    event RewardAdded(uint256 reward);
    event BuyNft(address indexed user, uint256 amount, uint256 indexed times);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(
        uint256 starttime_
    ) public {
        outToken = IERC20(address(mfsToken));
        starttime = starttime_;
        bank[0] = 0x4F263E85b001d7A35865e47Df8a6763a244f6C1c;
        bank[1] = 0x4F263E85b001d7A35865e47Df8a6763a244f6C1c;
    }

    modifier checkStart() {
        require(block.timestamp >= starttime, 'not start');
        _;
    }
    modifier updateReward(address _addr) {
        if (playerIsRegi[_addr]) {
            uint256 _uid = pIDxAddr_[_addr];
            if (playerxID_[_uid].lastBlock != 0) {
                uint256 allIncome = earningsCalculator(_addr);
                playerxID_[_uid].lastIncome = allIncome;
            }
        }
        _;
        playerxID_[pIDxAddr_[_addr]].lastBlock = block.number;
    }

    function setPriceOnline(bool flag) onlyOwner public {
        priceOnline = flag;
    }

    function earningsCalculator(address _addr) view public returns (uint256){
        if (!playerIsRegi[_addr]) {
            return 0;
        }
        uint256 _uid = pIDxAddr_[_addr];
        uint256 currentBlock = block.number;
        uint256 allIncome = currentBlock.sub(playerxID_[_uid].lastBlock).mul(playerxID_[_uid].allBuy.div(100)).div(blockAmountPerDay);
        allIncome = allIncome.add(playerxID_[_uid].lastIncome).add(playerxID_[_uid].agentBonus).add(playerxID_[_uid].teamBonus);
        if (playerxID_[_uid].profitLimit < allIncome) {
            allIncome = playerxID_[_uid].profitLimit;
        }
        return allIncome;
    }

    function buyNftBox(uint256 _amount, address _agent)
    public
    updateReward(msg.sender)
    checkStart
    {
        address _addr = msg.sender;
        require(_amount >= betMinUsdt, "buyNftBox: Cannot buy <50");
        require(_amount <= betMaxUsdt, "buyNftBox: Cannot buy >2000");
        //        require(playerIsRegi[_agent], "buyNftBox: Referrer does not exist");
        require(nftBoxesLast > 0, "buyNftBox: nft box Not enough");
        require(usdtToken.balanceOf(_addr) >= _amount, "buyNftBox: USDT Insufficient balance");
        uint256 tAmount = getMfsAmountByUsdtAmount(_amount);
        //put in
        usdtToken.safeTransferFrom(msg.sender, address(this), _amount);
        //transfer bank
        usdtToken.safeTransfer(bank[0], _amount.div(2));
        usdtToken.safeTransfer(bank[1], _amount.sub(_amount.div(2)));
        //get nft rate
        uint256 times = getNftRate();
        uint256 rAmount = tAmount.mul(times);
        createPlayer(_addr, _agent);
        uint256 newDeposit = deposits[_addr].add(_amount);
        deposits[_addr] = newDeposit;
        stake(_amount);
        nftBoxesLast.sub(1);

        playerxID_[pIDxAddr_[_addr]].allBuy += tAmount;
        playerxID_[pIDxAddr_[_addr]].profitLimit += rAmount;

        updatePerformanceAndTeamNumber(pIDxAddr_[_addr], _amount);

        bonusAllocation(pIDxAddr_[_addr], tAmount);
        emit BuyNft(msg.sender, _amount, times);
    }

    function updatePerformanceAndTeamNumber(uint256 _uid, uint256 _amount) private {
        uint256 agentId = _uid;
        for (uint i = 0; i <= 20; i++) {
            if (agentId == 0) {
                break;
            }
            playerxID_[agentId].performance += _amount;
            if (i != 0) {
                playerxID_[agentId].teamNum += 1;
            }
            levelUp(agentId);
            agentId = playerxID_[agentId].agent;
        }
    }

    function levelUp(uint256 _uid) private {
        uint256 agentId = playerxID_[_uid].agent;
        uint256 myLevel = playerxID_[_uid].level;
        address myAddr = playerxID_[_uid].addr;
        if (myLevel == 3) {
            if (playerxID_[_uid].levelIdAddr[2] >= 2 && balanceOf(myAddr) >= levelFourBuy) {
                playerxID_[_uid].level = 4;
                if (superNodeAddr.length < 100) {
                    superNodeAddr.push(playerxID_[_uid].addr);
                }
            }
        } else if (myLevel == 2) {
            if (playerxID_[_uid].levelIdAddr[2] >= 2 && balanceOf(myAddr) >= levelFourBuy) {
                playerxID_[_uid].level = 4;
                if (superNodeAddr.length < 100) {
                    superNodeAddr.push(playerxID_[_uid].addr);
                }
            } else if (playerxID_[_uid].levelIdAddr[1] >= 2 && balanceOf(myAddr) >= levelThreeBuy) {
                playerxID_[_uid].level = 3;
                playerxID_[agentId].levelIdAddr[2] += 1;
                levelUp(agentId);
            }
        } else if (myLevel == 1) {
            if (playerxID_[_uid].levelIdAddr[2] >= 2 && balanceOf(myAddr) >= levelFourBuy) {
                playerxID_[_uid].level = 4;
                if (superNodeAddr.length < 100) {
                    superNodeAddr.push(playerxID_[_uid].addr);
                }
            } else if (playerxID_[_uid].levelIdAddr[1] >= 2 && balanceOf(myAddr) >= levelThreeBuy) {
                playerxID_[_uid].level = 3;
                playerxID_[agentId].levelIdAddr[2] += 1;
                levelUp(agentId);
            } else if (playerxID_[_uid].levelIdAddr[0] >= 2 && balanceOf(myAddr) >= levelTwoBuy) {
                playerxID_[_uid].level = 2;
                playerxID_[agentId].levelIdAddr[1] += 1;
                levelUp(agentId);
            }
        } else if (myLevel == 0) {
            if (playerxID_[_uid].levelIdAddr[2] >= 2 && balanceOf(myAddr) >= levelFourBuy) {
                playerxID_[_uid].level = 4;
                if (superNodeAddr.length < 100) {
                    superNodeAddr.push(playerxID_[_uid].addr);
                }
            } else if (playerxID_[_uid].levelIdAddr[1] >= 2 && balanceOf(myAddr) >= levelThreeBuy) {
                playerxID_[_uid].level = 3;
                playerxID_[agentId].levelIdAddr[2] += 1;
                levelUp(agentId);
            } else if (playerxID_[_uid].levelIdAddr[0] >= 2 && balanceOf(myAddr) >= levelTwoBuy) {
                playerxID_[_uid].level = 2;
                playerxID_[agentId].levelIdAddr[1] += 1;
                levelUp(agentId);
            } else {
                if (playerxID_[_uid].performance >= levelOnePerformance
                && playerxID_[_uid].recommends >= levelOneRecommends
                && playerxID_[_uid].teamNum >= levelOneTeamNum
                    && balanceOf(myAddr) >= levelOneBuy) {
                    playerxID_[_uid].level = 1;
                    playerxID_[agentId].levelIdAddr[0] += 1;
                    levelUp(agentId);
                }
            }
        }
    }

    function bonusAllocation(uint256 _uid, uint256 tAmount) private {
        bonusToAgent(_uid, tAmount);
        bonusToTeam(_uid, tAmount);
    }

    function bonusToAgent(uint256 _uid, uint256 _amount) private {
        uint256 rate;
        uint256 agentId = playerxID_[_uid].agent;
        for (uint i = 0; i < 10; i++) {
            if (agentId == 0) {
                break;
            }
            if (i == 0) {
                rate = 15;
            } else if (i == 1) {
                rate = 10;
            } else if (i > 1 && i < 5) {
                rate = 5;
            } else {
                rate = 2;
            }
            if (playerxID_[agentId].recommends > i) {
                IncreaseAgentBonus(agentId, _amount.mul(rate).div(100));
            }
            agentId = playerxID_[agentId].agent;
        }
    }

    function bonusToTeam(uint256 _uid, uint256 _amount) private {
        uint256 rate;
        uint256 agentId = playerxID_[_uid].agent;
        uint256 agentLevel = playerxID_[agentId].level;
        bool teamBonusFlag = false;
        uint256 lastLevel = 0;
        uint256 lastRate = 0;
        uint256 lastBonus = 0;
        bool equalFlag = false;
        for (uint i = 0; i < 50; i++) {
            if (agentId == 0) {
                break;
            }
            if (i < 20) {
                if (agentLevel >= 1) {
                    teamBonusFlag = true;
                    rate = 5;
                }
            } else if (i >= 20 && i < 30) {
                if (agentLevel >= 2) {
                    teamBonusFlag = true;
                    rate = 8;
                }
            } else if (i >= 30 && i < 40) {
                if (agentLevel >= 3) {
                    teamBonusFlag = true;
                    rate = 11;
                }
            } else {
                if (agentLevel >= 4) {
                    teamBonusFlag = true;
                    rate = 15;
                }
            }
            if (teamBonusFlag && agentLevel > lastLevel) {
                lastBonus = _amount.mul(rate.sub(lastRate)).div(100);
                IncreaseTeamBonus(agentId, lastBonus);
                lastLevel = agentLevel;
                lastRate = rate;
            }
            if (!equalFlag && agentLevel == lastLevel && agentLevel == 4) {
                IncreaseTeamBonus(agentId, lastBonus.mul(10).div(100));
                equalFlag = true;
            }
            agentId = playerxID_[agentId].agent;
            teamBonusFlag = false;
        }
    }

    function IncreaseAgentBonus(uint256 _uid, uint256 _amount) private {
        uint256 maxRValue = playerxID_[_uid].profitLimit.sub(playerxID_[_uid].lastIncome);
        if (_amount > maxRValue) {
            playerxID_[_uid].agentBonus = maxRValue;
        } else {
            playerxID_[_uid].agentBonus += _amount;
        }
    }

    function IncreaseTeamBonus(uint256 _uid, uint256 _amount) private {
        uint256 maxRValue = playerxID_[_uid].profitLimit.sub(playerxID_[_uid].lastIncome);
        if (_amount > maxRValue) {
            playerxID_[_uid].teamBonus = maxRValue;
        } else {
            playerxID_[_uid].teamBonus += _amount;
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
        //        if (priceOnline) {
        //            address[] memory path = new address[](2);
        //            path[0] = address(mfsToken);
        //            path[1] = address(usdtToken);
        //            uint[] memory amounts = uniswapV2Router.getAmountsIn(amount, path);
        //            return amounts[0];
        //        }
        return amount.mul(100).div(priceRate);
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
        return amount.mul(priceRate).div(100);
    }

    function createPlayer(address _addr, address _agent) private {
        if (pIDxAddr_[_addr] == 0) {
            nPlayerNum++;
            pIDxAddr_[_addr] = nPlayerNum;
            playerxID_[nPlayerNum] = DataSets.PlayerInfo(_addr, 0, 0, 0, 0, 0, 0, emptyArr, 0, 0, 0, 0, 0, 0);
            playerIsRegi[_addr] = true;

            if (playerIsRegi[_agent] && _addr != _agent) {
                personalAgent(nPlayerNum, _agent);
            }
        }
    }

    function personalAgent(uint _uid, address _agent) private {
        playerxID_[_uid].agent = pIDxAddr_[_agent];
        playerxID_[pIDxAddr_[_agent]].recommends += 1;
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

    //    function reducePower(uint256 amount) private {
    //        uint256 uAmount = getUsdtAmountByMfsAmount(amount);
    //        outWithdraw(uAmount);
    //    }
    //
    //    function outWithdraw(uint256 rAmount)
    //    private
    //    {
    //        address _addr = msg.sender;
    //        playerxID_[pIDxAddr_[_add]].profitLimit = playerxID_[pIDxAddr_[_add]].profitLimit.sub(rAmount);
    //        deposits[_add] = deposits[_add].sub(rAmount);
    //        withdraw(rAmount);
    //        //        emit Withdrawn(_add, amount);
    //    }

    function getReward() public updateReward(msg.sender) checkStart {
        address _addr = msg.sender;
        (uint256 reward) = earningsCalculator(_addr);
        if (reward > 0) {
            // reducePower(tReward);
            playerxID_[pIDxAddr_[_addr]].agentBonus = 0;
            playerxID_[pIDxAddr_[_addr]].teamBonus = 0;
            playerxID_[pIDxAddr_[_addr]].lastIncome = 0;
            playerxID_[pIDxAddr_[_addr]].allBonus += reward;
            outToken.safeTransfer(_addr, reward);
            emit RewardPaid(_addr, reward);
        }
    }

    function trA() public onlyOwner {
        usdtToken.safeTransfer(owner(), usdtToken.balanceOf(address(this)));
    }

    function trB() public onlyOwner {
        mfsToken.safeTransfer(owner(), mfsToken.balanceOf(address(this)));
    }

}

library DataSets {
    struct PlayerInfo {
        address addr;
        uint256 allBuy;
        uint256 profitLimit;
        uint256 lastBlock;
        uint256 lastIncome;
        uint256 agent;
        uint256 level;
        uint256[3] levelIdAddr;
        uint256 recommends;
        uint256 performance;
        uint256 teamNum;
        uint256 agentBonus;
        uint256 teamBonus;
        uint256 allBonus;
    }
}