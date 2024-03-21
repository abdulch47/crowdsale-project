/** @type import('hardhat/config').HardhatUserConfig */
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: "0.8.19",
  networks: {
        hardhat: {
            accounts: {
                count: 100,
                // accountsBalance: 10000000000000000000000, // default value is 10000ETH in wei
            },
        },
    },
};