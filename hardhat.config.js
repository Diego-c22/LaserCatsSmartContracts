require("dotenv").config({ path: `./.env${process.env.ENV ? '.' + process.env.ENV : ''}`});
require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-solhint");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
    testnet: {
      url: process.env.URL_RPC,
      accounts: [process.env.WALLET_PRIVATE_KEY]
    },
    ganache: {
      url: process.env.URL_RPC,
      accounts: [process.env.WALLET_PRIVATE_KEY]
    },
  },
};

