// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {IERC20SendAndCallReceiver} from "@ICTT/src/interfaces/IERC20SendAndCallReceiver.sol";
import {IERC20TokenTransferrer} from "@ICTT/src/interfaces/IERC20TokenTransferrer.sol";
import {ERC20TokenRemote} from "@ICTT/src/TokenRemote/ERC20TokenRemote.sol";
import {SafeERC20} from "@ICTT/lib/teleporter/contracts/lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@ICTT/lib/teleporter/contracts/lib/openzeppelin-contracts/contracts/interfaces/IERC20.sol";
import {SendTokensInput} from "@ICTT/src/interfaces/ITokenTransferrer.sol";

contract VaultRemote is IERC20SendAndCallReceiver {
    // mapping address -> number of token
    mapping(address => uint256) public addressToAmount;

    // constant variables to update before deploying this contract
    address private constant tokenRemoteAddress =
        0x52C84043CD9c865236f11d9Fc9F56aa003c1f922;
    bytes32 private constant sourceChainID =
        0xa385ca0a1e31f503a5acd664371e0cfa0a87f707e82ea975c0bb020eb22ed34b;
    address private constant tokenHomeAddress =
        0x17aB05351fC94a1a67Bf3f56DdbB941aE6c63E25;
    address private constant recipient =
        0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC;

    function receiveTokens(
        bytes32 sourceBlockchainID,
        address originTokenTransferrerAddress,
        address originSenderAddress,
        address token,
        uint256 amount,
        bytes calldata payload
    ) external {
        (address senderAddress, uint256 tokenAmount, bool addToMapping) = abi
            .decode(payload, (address, uint256, bool));
        if (addToMapping) {
            addressToAmount[senderAddress] += tokenAmount;
        } else {
            send(senderAddress, tokenAmount);
        }
    }

    function send(address sender, uint256 amount) public {
        SafeERC20.safeIncreaseAllowance(
            IERC20(tokenRemoteAddress),
            address(this),
            amount
        );
        SendTokensInput memory input = SendTokensInput(
            sourceChainID,
            tokenHomeAddress,
            sender,
            tokenRemoteAddress,
            0,
            0,
            100000,
            address(0)
        );
        IERC20TokenTransferrer(tokenRemoteAddress).send(input, amount);
        addressToAmount[sender] -= amount;
    }

    function getAmountFromAddress(
        address sender
    ) public view returns (uint256) {
        return addressToAmount[sender];
    }
}
