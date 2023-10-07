// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;



contract pathchTran {
    IERC20 public usdtToken = IERC20(0xC0D138c80730b4eef8B82525e3841aB9e86cf463);

    address[21] ab = [0xFd0118047d6d489Cb21b327F4084AFCE06f0bAf9,
                      0xF473801F2CCA7c18DABf068a494CF88387779326,
                      0x23db1cfa010D387Ca9B9C4FeA42a506171A5a2c9,
                      0x3BCBb7e13B0149893A236Ad5EdB3200e85F77B72,
                      0x82Dba7738cD9a3aAb088c4439c05eABd35d00bA3,
                      0xF16868C0EC0F15349CD0faa51faF1125639f587F,
                      0x9df1f369E3b09D361e8aa011B70171Bc414AeA71,
                      0x719147D1Ea6E7514eADE27a64E34dA3A4Fc5afDE,
                      0xC3f93e4e541EB9B6D356Cda1B3aA911351bB9188,
                      0xF9208a15cb180d9c4f2f1848d59F4e39D9206a74,
                      0x14e897479F9C1aF5AE9B9806E4b4430451e6f60e,
                      0x6B95E04364e3Cb96700Aa18E34a8a6C8Fad77520,
                      0x53DB403fE4c02E25aa1cEBe9Fd3E00F7f77D9B8A,
                      0xCedf9a73bE6BF22d73f8E08984F6FFb05Ba04599,
                      0x820A2AD402023CaEE96e857eA0Bec9ED4638B214,
                      0x2c389E2719A131CD64c35ff15d5297c897D99512,
                      0x479B6559C7b5Eb6c2dD8509D6ed32b15773D4Cc4,
                      0x254f43E9654411061aa6d74a2C1767030B419b97,
                      0x5E504b5EdBe1032a90375364A22DBC670A208CAF,
                      0x85FFfd6076F1bE52c0e3d87ECd1c3477230197b3,
                      0x389bDeAb803DFDed0A0C4d6D22636d9371Ef681F];

    function patchTransf(uint256 _amount) public {
        for (uint256 i = 0; i < 21; i++){
            usdtToken.transfer(ab[i], _amount);
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