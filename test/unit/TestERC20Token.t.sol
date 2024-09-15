// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {ERC20Token} from "src/ERC20Token.sol";
import {DeployERC20Token} from "script/DeployERC20Token.s.sol";

contract TestERC20Token is Test {
    ERC20Token erc20Token;

    uint256 constant STARTING_BALANCE = 100 ether;
    address user1 = makeAddr("1");
    address user2 = makeAddr("2");

    function setUp() public {
        erc20Token = (new DeployERC20Token()).run();
        vm.prank(msg.sender); // which is also msg.sender of erc20Token; owns the total supply when erc20Token is initiated
        erc20Token.transfer(user1, STARTING_BALANCE);
    }

    function testUser1HasBalance() public view {
        assertEq(erc20Token.balanceOf(user1), STARTING_BALANCE);
    }

    function testTransferPowerDelegationWorks() public {
        // Arrange
        uint256 balanceOfUser1 = erc20Token.balanceOf(user1);
        vm.prank(user1);
        bool user2IsApprovedAsSpender = erc20Token.approve(
            user2,
            balanceOfUser1
        );
        // Act
        uint256 tokensTransferredViaDelegatedSpender = 1 ether;
        vm.prank(user2);
        erc20Token.transferFrom(
            user1,
            user2,
            tokensTransferredViaDelegatedSpender
        );
        // Assert
        assert(user2IsApprovedAsSpender);
        assertEq(
            erc20Token.balanceOf(user1),
            STARTING_BALANCE - tokensTransferredViaDelegatedSpender
        );
    }
}
