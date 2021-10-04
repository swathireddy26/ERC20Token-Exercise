// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title ERC20Interface
 * @dev Simpler version of ERC20 interface
 */
interface ERC20Interface {
  function totalSupply() external view returns (uint256);
  function balanceOf(address _who) external view returns (uint256);
  function transfer(address _to, uint256 _value) external returns (bool);
  function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
  function allowance(address owner, address delegate) external view returns (uint256);
  function approve(address delegate, uint256 amount) external returns (bool);

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}
