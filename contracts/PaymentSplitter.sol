// SPDX-License-Identifier: MIT
/*
 * PaymentSplitter
 *
 * The splitPayment function allows a caller to send ERC-20 tokens and divide them
 * between two recipients in any amounts specified at the time of the call.
 *
 * Why approve the token before calling splitPayment?
 * - ERC-20 tokens require the caller to first approve this contract to transfer tokens
 *   on their behalf. Without approval, transferFrom() will fail.
 * - Approving ensures the contract can safely pull the specified total amount from the caller
 *   and then distribute the exact amounts to the recipients.
 */
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PaymentSplitter is Ownable {
    event PaymentSplit(
        address indexed from,
        address indexed recipientA,
        address indexed recipientB,
        uint256 amountA,
        uint256 amountB
    );

    // ✅ Pass msg.sender to Ownable so deployer becomes the owner
    constructor() Ownable(msg.sender) {}

    /**
     * @notice Splits a payment of ERC-20 tokens between two recipients
     * @param tokenA The ERC-20 token address to split
     * @param recipientA First recipient
     * @param recipientB Second recipient
     * @param amountA Amount of tokens to send to recipientA
     * @param amountB Amount of tokens to send to recipientB
     */
    function splitPayment(
        address tokenA,
        address recipientA,
        address recipientB,
        uint256 amountA,
        uint256 amountB
    ) external {
        require(tokenA != address(0), "Invalid token");
        require(recipientA != address(0) && recipientB != address(0), "Invalid recipients");
        require(amountA > 0 || amountB > 0, "Amounts must be > 0");

        IERC20 token = IERC20(tokenA);
        uint256 total = amountA + amountB;

        // Transfer tokens from caller to contract
        require(token.transferFrom(msg.sender, address(this), total), "Transfer failed");

        // Send tokens to recipients
        require(token.transfer(recipientA, amountA), "Transfer to recipientA failed");
        require(token.transfer(recipientB, amountB), "Transfer to recipientB failed");

        emit PaymentSplit(msg.sender, recipientA, recipientB, amountA, amountB);
    }
}
