// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "./ERC20Interface.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @title Basic ERC20 token
 */
contract ERC20 is ERC20Interface {
    using SafeMath for uint256;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;
    string private _name;
    string private _symbol;

     /**
     * @dev Sets the values for {name} and {symbol}.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

     /**
     * @dev Returns the symbol of the token
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation
     */
    function decimals() public pure returns (uint8) {   
        return 7;
    }
    /**
    * @dev total number of tokens in existence
    */
    function totalSupply() public view override returns (uint256) {
      return totalSupply_;
    }

    /**
    * @dev transfer token to a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) public virtual override returns (bool) {
      _transfer(msg.sender, _to, _value);
      return true;
    }
 

    /**
    * @dev transfer token from one address to address
    * @param _from The address to transfertokens  from.
    * @param _to The address to transfer tokens to.
    * @param _value The amount to be transferred.
    */
    function transferFrom(address _from, address _to, uint256 _value) public virtual override returns (bool) {
      _transfer(_from, _to, _value);
      return true;
    }

    function _transfer(address _from, address _to, uint256 _value) internal virtual{
      require(_from != address(0), "ERC20: transfer from the zero address");
      require(_to != address(0), "ERC20: transfer to the zero address");
      require(_value <= balances[_from], "ERC20: Not enough tokens");

      balances[_from] = balances[_from].sub(_value);
      balances[_to] = balances[_to].add(_value);
      emit Transfer(msg.sender, _to, _value);
    }


    /**
    * @dev Gets the balance of the specified address.
    * @param _who The address to query the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _who) public view override returns (uint256) {
      return balances[_who];
    }
                 
    /**
    * @dev Creates '_amount' of tokens and assigns them to the '_account'
    * @param _account The address to which minted tokens are added
    * @param _amount The amount of tokens to be minted
    */
    function _mint(address _account, uint256 _amount) internal  {
        require(_account != address(0), "ERC20: mint to the zero address");

        totalSupply_ = totalSupply_.add(_amount);
        balances[_account] = balances[_account].add(_amount);
        emit Transfer(address(0), _account, _amount);
    }

    /**
     * @dev Sets `numTokens` as the allowance of `delegate` over the `owner` s tokens.
     */
    function approve(address delegate,
                uint numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    /**
     * @dev returns the allowance of the delegate.
     */
    function allowance(address owner,
                  address delegate) public view override returns (uint) {
        return allowed[owner][delegate];
    }

}