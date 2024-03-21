**Token Contract Test Cases**

This repository contains test cases for a Token smart contract and a Crowdsale smart contract implemented in Solidity. The test cases are written using Chai for assertions and Hardhat for Ethereum development. The purpose of these test cases is to ensure that the contracts function as intended and to verify their behavior under different scenarios.

### Prerequisites
- Node.js installed on your machine
- Hardhat Ethereum development environment set up

### Installation
1. Clone this repository to your local machine.
2. Navigate to the project directory in your terminal.
3. Run `npm install` to install the required dependencies.

### Running the Tests
1. Ensure that you are in the project directory in your terminal.
2. Run `npx hardhat test` to execute all the test cases.

### Token Contract Test Cases

1. **Immutable Metadata Verification**
   - Verifies that the immutable metadata for the Token contract is correctly set.
   - Checks the name, symbol, and total supply of the token.
   - Assertion checks include verifying the name and symbol of the token.
   
2. **Token Transfer**
   - Tests the functionality of transferring tokens from one address to another.
   - Verifies that the token balances are updated correctly after the transfer.

3. **Token Transfer From One Account to Another**
   - Tests the functionality of transferring tokens from one account to another using the `transferFrom` function.
   - Verifies that the allowance mechanism works as expected and that the balances are updated correctly after the transfer.

4. **Approve Spender to Spend Tokens**
   - Tests the functionality of approving a spender to spend tokens on behalf of the owner.
   - Verifies that the allowance is set correctly after approval.

### Crowdsale Contract Test Cases

1. **Start Sale**
   - Logs the start time and end time of the crowdsale.
   - Verifies that the start time and end time are set correctly.

2. **Set Cliff Time and Vesting Time**
   - Verifies that the cliff time and vesting time are set correctly during contract deployment.

3. **Start the Sale**
   - Tests the functionality of starting the crowdsale.
   - Verifies that the sale is active after starting.

4. **Fund Tokens into the Contract**
   - Tests the functionality of funding tokens into the crowdsale contract.
   - Verifies that the token balance of the contract increases after funding.

5. **Log Tokens per ETH Price**
   - Logs the price of tokens per ETH.

6. **Buy Tokens**
   - Tests the functionality of buying tokens during the crowdsale.
   - Verifies that the buyer's token balance increases after purchase.

7. **Halt the Sale**
   - Tests the functionality of halting the crowdsale.
   - Verifies that the sale is inactive after halting.

8. **Restart the Sale**
   - Tests the functionality of restarting the crowdsale after halting.
   - Verifies that the sale is active after restarting.

9. **Release Vested Tokens**
   - Tests the functionality of releasing vested tokens to the buyer.
   - Verifies that the vested tokens are released correctly.

