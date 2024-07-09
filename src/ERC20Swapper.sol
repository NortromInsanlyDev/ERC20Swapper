// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20Swapper} from "./IERC20Swapper.sol";
import {IUniswapV2Router02} from "./interfaces/IUniswapV2Router02.sol";
import {Initializable} from "./../lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";

contract ERC20Swapper is Initializable, IERC20Swapper {
    IUniswapV2Router02 internal router;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _router) public initializer {
        router = IUniswapV2Router02(_router);
    }

    function swapEtherToToken(
        address token,
        uint256 minAmount
    ) external payable returns (uint256) {
        address[] memory path = new address[](2);
        path[0] = router.WETH();
        path[1] = token;
        uint256[] memory amounts = router.swapExactETHForTokens{
            value: msg.value
        }(minAmount, path, msg.sender, block.timestamp);
        return amounts[1];
    }
}
