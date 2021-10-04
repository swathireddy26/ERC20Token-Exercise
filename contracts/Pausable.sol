// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable {
    event Paused(address account);
    event Unpaused(address account);

    bool public paused = false;

    /**
    * @dev Modifier to make a function callable only when the contract is not paused.
    */
    modifier whenNotPaused() {
        require(!paused, "Pausable: paused");
        _;
    }

    /**
    * @dev Modifier to make a function callable only when the contract is paused.
    */
    modifier whenPaused() {
        require(paused, "Pausable: Not paused");
        _;
    }

    /**
    * @dev called by the owner to pause, triggers stopped state
    **/
    function _pause() whenNotPaused public {
            paused = true;
            emit Paused(msg.sender);
        }

    /**
    * @dev called by the owner to unpause, returns to normal state
    */
    function _unpause() whenPaused public {
        paused = false;
        emit Unpaused(msg.sender);
    }
}