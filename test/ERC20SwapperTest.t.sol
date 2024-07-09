// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20Swapper} from "./../src/ERC20Swapper.sol";
import {Test, console} from "forge-std/Test.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract ERC20SwaperTest is Test {
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    ERC20Swapper private swapper;

    uint256 mainnetFork;
    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    address proxyAdmin = address(1);

    function setUp() public {
        uint256 forkBlock = 20256882;
        mainnetFork = vm.createSelectFork(MAINNET_RPC_URL, forkBlock);
        vm.selectFork(mainnetFork);
        address proxy = Upgrades.deployTransparentProxy(
            "ERC20Swapper.sol",
            proxyAdmin,
            abi.encodeCall(ERC20Swapper.initialize, (UNISWAP_V2_ROUTER))
        );
        swapper = ERC20Swapper(proxy);
    }

    function testSwapEtherToToken() public {
        uint256 daiAmountMin = 2000e18;
        uint256 daiAmountOut = swapper.swapEtherToToken{value: 1 ether}(
            DAI,
            daiAmountMin
        );
        assertGe(daiAmountOut, daiAmountMin);
        console.log(daiAmountOut);
    }
}
