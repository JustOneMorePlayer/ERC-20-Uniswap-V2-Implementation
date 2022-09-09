const { getNamedAccounts, ethers } = require("hardhat");

async function main() {
  const { acc00 } = await getNamedAccounts();
  const WrappedToken = await ethers.getContract("WrappedToken", acc00);

  await WrappedToken.wrapEther({ value: ethers.utils.parseEther("1") });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
