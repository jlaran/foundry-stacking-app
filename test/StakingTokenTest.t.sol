// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import "../lib/forge-std/src/Test.sol";
import "../src/StakingToken.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract StakingTokenTest is Test {

    StakingToken stakingToken;
    string name_ = "Staking token";
    string symbol_ = "STK";
    address randomUser = vm.addr(1);

    function setUp() public{
        stakingToken = new StakingToken(name_, symbol_);
    }

    function testStakingTokenMintsCorrectly() public {
        vm.startPrank(randomUser);
        uint256 amount_ = 1 ether;

        // Token Balance previous
        uint256 balanceBefore = IERC20(address(stakingToken)).balanceOf(randomUser);

        // Mint action
        stakingToken.mint(amount_);

        // Token Balance after
        uint256 balanceAfter = IERC20(address(stakingToken)).balanceOf(randomUser);

        assert(balanceAfter - balanceBefore == amount_);

        vm.stopPrank();
    }

}