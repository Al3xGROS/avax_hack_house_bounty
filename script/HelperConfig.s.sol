// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {WarpMessengerMock} from "../src/mocks/WarpMessengerMock.sol";
import {Script, console} from "forge-std/Script.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 deployerKey;
        address warpPrecompileAddress;
        address teleporterManager;
        address tokenAddress;
        string tokenName;
        string tokenSymbol;
        address tokenHomeTeleporterRegistryAddress;
        bytes32 tokenHomeBlockchainID;
        uint8 tokenHomeTokenDecimals;
        address tokenHomeAddress;
        address tokenRemoteTeleporterRegistryAddress;
        uint8 tokenRemoteTokenDecimals;
        WarpMessengerMock warpMessengerMock;
    }

    uint256 public _deployerKey =
        0x56289e99c94b6912bfc12adc093c9b51124f0dc54ac7a766b2bc5ccf558d8027;
    address public _warpPrecompileAddress =
        0x0200000000000000000000000000000000000005;
    bytes32 public _messageID =
        0x39fa07214dc7ff1d2f8b6dfe6cd26f6b138ee9d40d013724382a5c539c8641e2;
    address public _teleporterManager =
        0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC;
    bytes32 public _tokenHomeBlockchainID =
        0xa385ca0a1e31f503a5acd664371e0cfa0a87f707e82ea975c0bb020eb22ed34b;

    NetworkConfig public activeNetworkConfig;

    uint256 public homeChainId = 1;
    uint256 public remoteChainId = 2;

    constructor() {
        if (block.chainid == homeChainId) {
            activeNetworkConfig = getHomeChainConfig();
        } else if (block.chainid == remoteChainId) {
            activeNetworkConfig = getRemoteChainConfig();
        }
    }

    function getHomeChainConfig() public returns (NetworkConfig memory) {
        address _tokenHomeTeleporterRegistryAddress = 0xe0B992c27C15800930569A6F70066B28206A1cDA;
        address _tokenAddress = 0x52C84043CD9c865236f11d9Fc9F56aa003c1f922;
        uint8 _tokenDecimals = 18;
        WarpMessengerMock warpMessengerMock = new WarpMessengerMock(
            _tokenHomeBlockchainID,
            _messageID
        );
        return
            NetworkConfig({
                deployerKey: _deployerKey,
                warpPrecompileAddress: _warpPrecompileAddress,
                teleporterManager: _teleporterManager,
                tokenAddress: _tokenAddress,
                tokenName: "",
                tokenSymbol: "",
                tokenHomeTeleporterRegistryAddress: _tokenHomeTeleporterRegistryAddress,
                tokenHomeBlockchainID: _tokenHomeBlockchainID,
                tokenHomeTokenDecimals: _tokenDecimals,
                tokenHomeAddress: address(0),
                tokenRemoteTeleporterRegistryAddress: address(0),
                tokenRemoteTokenDecimals: 0,
                warpMessengerMock: warpMessengerMock
            });
    }

    function getRemoteChainConfig() public returns (NetworkConfig memory) {
        bytes32 _currentBlockchainID = 0x5b3f96559cabd7095a8c67596762c895480fcbc1086bfb85d1f84642053e18ff;
        address _tokenRemoteTeleporterRegistryAddress = 0xe0B992c27C15800930569A6F70066B28206A1cDA;
        address _tokenHomeAddress = 0x17aB05351fC94a1a67Bf3f56DdbB941aE6c63E25;
        string memory _tokenName = "RandomToken";
        string memory _tokenSymbol = "RDT";
        uint8 _tokenDecimals = 18;
        WarpMessengerMock _warpMessengerMock = new WarpMessengerMock(
            _currentBlockchainID,
            _messageID
        );
        return
            NetworkConfig({
                deployerKey: _deployerKey,
                warpPrecompileAddress: _warpPrecompileAddress,
                teleporterManager: _teleporterManager,
                tokenAddress: address(0),
                tokenName: _tokenName,
                tokenSymbol: _tokenSymbol,
                tokenHomeTeleporterRegistryAddress: address(0),
                tokenHomeBlockchainID: _tokenHomeBlockchainID,
                tokenHomeTokenDecimals: _tokenDecimals,
                tokenHomeAddress: _tokenHomeAddress,
                tokenRemoteTeleporterRegistryAddress: _tokenRemoteTeleporterRegistryAddress,
                tokenRemoteTokenDecimals: _tokenDecimals,
                warpMessengerMock: _warpMessengerMock
            });
    }
}
