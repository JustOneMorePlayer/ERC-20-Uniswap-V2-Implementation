const { getNamedAccounts, ethers } = require("hardhat");

async function main() {
  const { deployer } = await getNamedAccounts();
  const WrappedToken = await ethers.getContract("WrappedToken", deployer);

  await WrappedToken.wrapEther({ value: ethers.utils.parseEther("1") });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
