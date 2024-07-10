// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@ICTT/lib/teleporter/contracts/lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract RandomToken is ERC20 {
    constructor() ERC20("RandomToken", "RDT") {
        _mint(msg.sender, 69_420_000_000 * 10 ** 18);
    }
}
