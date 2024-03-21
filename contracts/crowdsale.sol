/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    function decimals() external view returns (uint8);

    function burn(uint256 amount) external;

    function burnFrom(address account, uint256 amount) external;

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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Crowdsale is Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    IERC20 public token;
    uint256 public totalTokens;
    uint256 public tokensPerETh;
    uint256 public startTimestamp;
    uint256 public endTimestamp;
    uint256 public cliffTime;
    uint256 public vestingTime;
    bool public isSaleActive;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public vestingStartTime;

    event TokensPurchased(address indexed purchaser, uint256 amount);

    modifier onlyWhileOpen() {
        require(
            block.timestamp >= startTimestamp &&
                block.timestamp < endTimestamp,
            "Crowdsale: Sale not active"
        );
        _;
    }

    constructor(
        IERC20 _token,
        uint256 _startTimestamp,
        uint256 _endTimestamp,
        uint256 _cliffTime,
        uint256 _vestingTime
    ) {
        require(
            address(_token) != address(0),
            "Crowdsale: Token address cannot be zero"
        );
        require(
            _endTimestamp > _startTimestamp,
            "Crowdsale: End time must be after start time"
        );
        require(
            _cliffTime < _vestingTime,
            "Cliff time should be less than vesting time"
        );

        token = _token;
        tokensPerETh = 1000000 * 10**token.decimals();
        startTimestamp = block.timestamp + _startTimestamp;
        endTimestamp = block.timestamp + _endTimestamp;
        cliffTime = _cliffTime;
        vestingTime = _vestingTime;
    }

    function startSale() external onlyOwner {
        require(!isSaleActive, "Sale is already active");
        isSaleActive = true;
    }

    function haltSale() external onlyOwner {
        require(isSaleActive, "Sale is not active");
        isSaleActive = false;
    }

    function buyTokens() external payable onlyWhileOpen nonReentrant {
        require(isSaleActive, "Crowdsale: Sale is not active");
        require(msg.value > 0, "Not enough amount paid");
        uint256 amount = checkTokens(msg.value);
        require(amount <= totalTokens, "Not enough tokens in sale");
        totalTokens = totalTokens.sub(amount);
        vestingStartTime[msg.sender] = block.timestamp;
        balances[msg.sender] = balances[msg.sender].add(amount);
        emit TokensPurchased(msg.sender, amount);
    }

    function releaseVestedTokens() external nonReentrant {
        uint256 unreleased = releasableAmount(msg.sender);
        require(unreleased > 0, "Crowdsale: No tokens to release");

        token.transfer(msg.sender, unreleased);
        balances[msg.sender] = balances[msg.sender].sub(unreleased);
    }

    function releasableAmount(address _beneficiary)
        public
        view
        returns (uint256)
    {
        if (block.timestamp < vestingStartTime[_beneficiary].add(cliffTime)) {
            return 0;
        } else if (
            block.timestamp >= vestingStartTime[_beneficiary].add(vestingTime)
        ) {
            return balances[_beneficiary];
        } else {
            uint256 vested = balances[_beneficiary]
                .mul(block.timestamp.sub(vestingStartTime[_beneficiary]))
                .div(vestingTime);
            return vested;
        }
    }
    
    function checkTokens(uint256 _amountInEth) public view returns(uint256){
        return _amountInEth.mul(tokensPerETh).div(10 ** token.decimals());
    }

    function withdrawEth() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function changeTokensPerEth(uint256 _tokensPerEth) external onlyOwner {
        tokensPerETh = _tokensPerEth;
    }

    function fundTokens(uint256 _amount) external onlyOwner {
        token.transferFrom(msg.sender, address(this), _amount);
        totalTokens = totalTokens.add(_amount);
    }

    function getTokenBalance() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function withdrawStuckTokens() external onlyOwner {
        uint256 _amount = getTokenBalance();
        require(_amount > 0, "Not enough tokens");
        token.transfer(msg.sender, _amount);
    }

    receive() external payable {}
}
