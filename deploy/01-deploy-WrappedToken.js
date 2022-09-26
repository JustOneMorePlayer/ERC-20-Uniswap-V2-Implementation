const { getNamedAccounts, ethers, deployments } = require("hardhat")

module.exports = async () => {
  const { deployer } = await getNamedAccounts()

  await deployments.deploy("WETHToken", {
    from: deployer,
    contract: "WrappedToken",
    args: ["Wrapped Ethereum", "WETH"],
    log: true,
  })


}


