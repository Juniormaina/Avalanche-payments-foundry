// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "openzeppelin/contracts/finance/PaymentSplitter.sol";
import "openzeppelin/contracts/finance/Escrow.sol";

contract DeployPayments is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Example payees and shares
        address[] memory payees = new address[](2);
        payees[0] = 0x066d4646Ce97959fa45a933065946ED5A162E686; 
        payees[1] = 0x7cb653d1c6E4Df222DE5106134707Ce2Eaa704A3;

        uint256[] memory shares = new uint256[](2);
        shares[0] = 50;
        shares[1] = 50;

        PaymentSplitter splitter = new PaymentSplitter(payees, shares);
        Escrow escrow = new Escrow();

        vm.stopBroadcast();
    }
}
