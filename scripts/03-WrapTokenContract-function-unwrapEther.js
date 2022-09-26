const { getNamedAccounts, ethers } = require("hardhat");

async function main() {
  const { deployer } = await getNamedAccounts();
  const WrappedToken = await ethers.getContract("WrappedToken", deployer);

  await WrappedToken.unwrapEther(ethers.utils.parseEther("0.5"));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
