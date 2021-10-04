// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "./Token.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Stakeable is Ownable{

    Token token;
    using SafeMath for uint256;
    constructor(address _add) {
        token = Token(_add);
    }
    uint256 public total_fee;
    address public treasury;
    /**
     * @notice
     * A stake struct is used to represent the way we store stakes, 
     * A Stake will contain the users address, the amount staked and a timestamp, 
     * Since which is when the stake was made
     */
    struct Stake{
        address user;
        uint256 amount;
        uint256 since;
    }
    
    /**
    * @notice 
    * stakeholders is used to keep track of the stakers
    */
    mapping(address => Stake) internal stakeholders;

    /**
    * @notice Staked event is triggered whenever a user stakes tokens, address is indexed to make it filterable
    */
    event Staked(address indexed user, uint256 amount, uint256 timestamp);

    /**
    * @notice UnStaked event is triggered whenever a user unstakes tokens, address is indexed to make it filterable
    */
    event UnStaked(address indexed user, uint256 amount, uint256 timestamp);

    /**
     * @notice This function is used by the user for staking
     * @param _amount The amount to be staked
     */
    function stake(uint256 _amount) public {
        require(_amount > 0, "Staking: Cannot stake nothing");
        require(_amount <= token.balanceOf(msg.sender), "Staking: Cannot stake more than what user has");
        uint256 timestamp = block.timestamp;
        uint256 fee = (_amount * 2) / 1000;
        total_fee = total_fee.add(fee);
        stakeholders[msg.sender].user =  msg.sender;
        stakeholders[msg.sender].amount =  _amount.sub(fee);
        stakeholders[msg.sender].since = timestamp;
        token.transferFrom(msg.sender, address(this), _amount);
        emit Staked(msg.sender, _amount, timestamp);
    }

    /**
    * @notice This function is used by the user for unstaking
    * @param _amount The amount to be unstaked
    */
     function unstake(uint256 _amount) public {
        require(stakeholders[msg.sender].amount >= _amount, "Staking: Cannot withdraw more than you have staked");
        require(block.timestamp.sub(stakeholders[msg.sender].since) >= 2 hours, "Staking: Withdraw only after expiry of lockin period");
        stakeholders[msg.sender].amount = stakeholders[msg.sender].amount.sub(_amount);
        token.transferFrom(address(this), msg.sender, _amount);
        emit UnStaked(msg.sender, _amount, block.timestamp);
     }

    /**
    * @dev function to set the treasury address by the Owner
    * @param _addr Address of the treasury
    */
    function setTreasury(address _addr) public onlyOwner {
        require(_addr != address(0), "Treasury address cannot be zero address");
        treasury = _addr;
    }

    /**
     * @dev function to collect fee by the owner
     */
    function collectFee() external onlyOwner {
        token.transfer(treasury, total_fee);
    }
}