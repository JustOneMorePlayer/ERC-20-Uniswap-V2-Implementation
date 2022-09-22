const { getNamedAccounts, ethers } = require("hardhat");

async function main() {
  const { acc00 } = await getNamedAccounts();
  const math = await ethers.getContract("Math", acc00);

  console.log((await math.sqrt(27)).toNumber());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
