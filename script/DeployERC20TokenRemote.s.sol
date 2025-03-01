// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {WarpMessengerMock} from "../../src/mocks/WarpMessengerMock.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {ERC20TokenRemote} from "@ICTT/src/TokenRemote/ERC20TokenRemote.sol";
import {TokenRemoteSettings} from "@ICTT/src/TokenRemote/interfaces/ITokenRemote.sol";
import {TeleporterFeeInfo} from "@teleporter/ITeleporterMessenger.sol";
import {Script, console} from "forge-std/Script.sol";

contract DeployERC20TokenRemote is Script {
    function run() external returns (ERC20TokenRemote) {
        HelperConfig helperConfig = new HelperConfig();
        (
            uint256 deployerKey,
            address warpPrecompileAddress,
            address teleporterManager,
            ,
            string memory tokenName,
            string memory tokenSymbol,
            ,
            bytes32 tokenHomeBlockchainID,
            uint8 tokenHomeTokenDecimals,
            address tokenHomeAddress,
            address teleporterRegistryAddress,
            uint8 tokenDecimals,
            WarpMessengerMock mock
        ) = helperConfig.activeNetworkConfig();

        vm.etch(warpPrecompileAddress, address(mock).code);

        TokenRemoteSettings memory settings = TokenRemoteSettings({
            teleporterRegistryAddress: teleporterRegistryAddress,
            teleporterManager: teleporterManager,
            tokenHomeBlockchainID: tokenHomeBlockchainID,
            tokenHomeAddress: tokenHomeAddress,
            tokenHomeDecimals: tokenHomeTokenDecimals
        });

        vm.startBroadcast(deployerKey);

        ERC20TokenRemote erc20TokenRemote = deployBridgeInstance(
            settings,
            tokenName,
            tokenSymbol,
            tokenDecimals
        );

        registerRemoteInstance(erc20TokenRemote);

        vm.stopBroadcast();

        return erc20TokenRemote;
    }

    function deployBridgeInstance(
        TokenRemoteSettings memory settings,
        string memory tokenName,
        string memory tokenSymbol,
        uint8 tokenDecimals
    ) public returns (ERC20TokenRemote) {
        ERC20TokenRemote erc20TokenRemote = new ERC20TokenRemote(
            settings,
            tokenName,
            tokenSymbol,
            tokenDecimals
        );

        return erc20TokenRemote;
    }

    function registerRemoteInstance(ERC20TokenRemote tokenRemoteBridge) public {
        TeleporterFeeInfo memory feeInfo = TeleporterFeeInfo({
            feeTokenAddress: address(tokenRemoteBridge),
            amount: 0
        });
        tokenRemoteBridge.approve(address(tokenRemoteBridge), 10 ether);
        tokenRemoteBridge.registerWithHome(feeInfo);
    }
}
