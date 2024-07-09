// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ERC20Swapper} from "./../src/ERC20Swapper.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract DeployERC20Swapper is Script {
    string SEPOLIA_RPC_URL = vm.envString("SEPOLIA_RPC_URL");
    address private constant UNISWAP_V2_ROUTER =
        0x425141165d3DE9FEC831896C016617a52363b687;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);
        address proxy = Upgrades.deployTransparentProxy(
            "ERC20Swapper.sol",
            deployer,
            abi.encodeCall(ERC20Swapper.initialize, (UNISWAP_V2_ROUTER))
        );

        console.log(proxy);

        vm.stopBroadcast();
    }
}
