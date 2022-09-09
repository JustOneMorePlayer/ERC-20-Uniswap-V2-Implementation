const { getNamedAccounts, ethers } = require("hardhat");

async function main() {
  const { acc00 } = await getNamedAccounts();

  const WrappedToken = await ethers.getContract("WrappedToken", acc00);
  console.log(`${await WrappedToken.name()} \t ${await WrappedToken.symbol()}`);
  console.log(`Total Supply: ${await WrappedToken.totalSupply()}\n`);
  let i = 0;

  for (value of Object.values(await getNamedAccounts())) {
    console.log(
      `Account #${i} ${value}: ${await WrappedToken.getBalanceOf(value)} \n`
    );
    i++;
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
