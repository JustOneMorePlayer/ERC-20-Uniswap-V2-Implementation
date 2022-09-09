const { getNamedAccounts, ethers } = require("hardhat");

async function main() {
  const { acc00 } = await getNamedAccounts();
  const WrappedToken = await ethers.getContract("WrappedToken", acc00);

  await WrappedToken.unwrapEther(ethers.utils.parseEther("0.5"));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
