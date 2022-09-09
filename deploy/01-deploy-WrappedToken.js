const { getNamedAccounts, ethers, deployments } = require("hardhat")

module.exports = async () => {
  const { acc00 } = await getNamedAccounts()

  await deployments.deploy("WrappedToken1", {
    from: acc00,
    contract: "WrappedToken",
    args: ["Wrapped Ethereum", "WETH"],
    log: true,
  })

  await deployments.deploy("WrappedToken2", {
    from: acc00,
    contract: "WrappedToken",
    args: ["Wrapped Ethereum", "WETH"],
    log: true,
  })
}
