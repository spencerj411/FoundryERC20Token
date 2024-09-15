// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {ERC20Token} from "src/ERC20Token.sol";

uint256 constant TOTAL_SUPPLY = 1000 ether;
string constant TOKEN_NAME = "My Token";
string constant TOKEN_TICKER_SYMBOL = "MTK";

contract DeployERC20Token is Script {
    function run() external returns (ERC20Token) {
        vm.startBroadcast();
        ERC20Token erc20Token = new ERC20Token(
            TOTAL_SUPPLY,
            TOKEN_NAME,
            TOKEN_TICKER_SYMBOL
        );
        vm.stopBroadcast();
        return erc20Token;
    }
}
