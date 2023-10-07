// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

//https://github.com/openzeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/IERC20.sol
//引用ERC20標準
interface IERC20 {
　　function name() external view returns (string memory);
　　function symbol() external view returns (string memory);
　　function decimals() external view returns (uint8);
　　function totalSupply() external view returns (uint256);
　　function balanceOf(address _owner) external view returns (uint256 balance);
　　function transfer(address _to, uint256 _value) external returns (bool success);
　　function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
　　function approve(address _spender, uint256 _value) external returns (bool success);
　　function allowance(address _owner, address _spender) external view returns (uint256 remaining);

　　event Transfer(address indexed _from, address indexed _to, uint256 _value);
　　event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract MyToken is IERC20 {
　　string private _name;
　　string private _symbol;
　　uint8 private _decimal;
　　uint256 private _totalSupply;

　　mapping (address => uint256) private balances; //cryto.eth => 1000, adam.eth => 500
　　mapping (address => mapping (address => uint256)) private allowances; // crypto(adam) =>, adam(zhangsan) => 100

　　//初始化
　　constructor(string memory _na, string memory _sym, uint8 _deci, uint256 _initialSupply) {
　　　　_name = _na;
　　　　_symbol = _sym;
　　　　_decimal = _deci;
　　　　_totalSupply = _initialSupply;

　　　　//初始化時先把錢打給自己
　　　　balances[msg.sender] = _initialSupply;
　　}

　　//下面寫入把ERC20的function各個override變自己的
　　function name() external override view returns (string memory) {
　　　　return _name;
　　}

　　function symbol() external override view returns (string memory) {
　　　　return _symbol;
　　}

　　function decimals() external override view returns (uint8) {
　　　　return _decimal;
　　}

　　function totalSupply() external override view returns (uint256) {
　　　　return _totalSupply;
　　}

　　function balanceOf(address _owner) external override view returns (uint256 balance) {
　　　　return balances[_owner];
　　}

　　//轉帳
　　function transfer(address _to, uint256 _amount) external returns (bool success) {
　　　　require(balances[msg.sender] > _amount, "Not enough amount!");

　　　　balances[msg.sender] -= _amount;
　　　　balances[_to] += _amount;

　　　　emit Transfer(msg.sender, _to, _amount);

　　　　return true;
　　}
　　
　　//從哪裡移轉出去
　　function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
　　　　//找到我(_from)的帳號給發起這個轉帳的人(msg.sender)足夠的金錢去花費(允許的數量)
　　　　uint _allowance = allowances[_from][msg.sender];
　　　　//剩餘數量=允許的數量 - 發送的數量
　　　　uint leftAllowance = _allowance - _value;
　　　　//檢查剩餘數量是否>0
　　　　require(leftAllowance >= 0, "Not enought allowance!");
　　　　//把剩餘的數量寫回允許的數量
　　　　allowances[_from][msg.sender] = leftAllowance;
　　　　//檢查我的(_from)剩餘餘額是否足夠
　　　　require(balances[_from] > _value, "Not enought Amount");
　　　　balances[_from] -= _value; //發送的錢包扣掉數量
　　　　balances[_to] += _value; //發送到的錢包加入此數量

　　　　emit Transfer(msg.sender, _to, _value);

　　　　return true;
　　}

　　//批准誰可以花我的錢
　　function approve(address _spender, uint256 _value) external override returns (bool success) {
　　　　allowances[msg.sender][_spender] = _value;

　　　　emit Approval(msg.sender, _spender, _value);
　　　　
　　　　return true;
　　}
　　
　　function allowance(address _owner, address _spender) external override view returns (uint256 remaining) {
　　　　return allowances[_owner][_spender];
　　}
}