// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC20.sol";
import "./Pausable.sol";

contract Token is ERC20, Pausable, Ownable {
    uint256 public constant INITIAL_SUPPLY = 1000 * 10 ** 7;

    /**
    * Basic Token Constructor
    * @dev Create and issue tokens to msg.sender.
    */
    constructor() ERC20("Thali token", "THALI") {
        _mint(owner(), INITIAL_SUPPLY);
    } 

    /**
     * @dev Called by the owner to mint Tokens
     * @param _to The address to mint tokens to.
     * @param _amount The amount to be transferred.
     **/
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    /**
     * @dev Called by the owner to pause the token
     **/
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @dev Called by the owner to unpause the Token
     **/
    function unpause() public onlyOwner {
        _unpause();
    }

     /**
     * @dev Transfer tokens when not paused
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     **/
    function transfer(address _to, uint256 _value) public override whenNotPaused returns (bool) {
        return super.transfer(_to, _value);
    }
    
    /**
     * @dev transferFrom function to tansfer tokens when token is not paused
     * @param _from the address from which amount to be transferred
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     **/
    function transferFrom(address _from, address _to, uint256 _value) public override whenNotPaused returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }
}