require("@nomicfoundation/hardhat-toolbox");
require("hardhat-deploy");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.12",
  namedAccounts: {
    deployer: {
      default: 0,
    },
    client: {
      default: 1,
    },
    acc02: {
      default: 2,
    },
    acc03: {
      default: 3,
    },
    acc04: {
      default: 4,
    },
  },
};
