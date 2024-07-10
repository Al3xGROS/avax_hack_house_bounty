// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {VaultRemote} from "../src/VaultRemote.sol";
import {Script, console} from "forge-std/Script.sol";

contract DeployVaultRemote is Script {
    function run() external returns (VaultRemote) {
        VaultRemote vaultRemote = new VaultRemote();
        return vaultRemote;
    }
}
