const { getNamedAccounts, ethers } = require("hardhat")

async function main() {
  let i = 0
  for (let value of Object.values(await getNamedAccounts())) {
    console.log(`Account #${i}: ${value}`)
    console.log(`Balance: ${await ethers.provider.getBalance(value)}\n`)
    i++
  }

  console.log(
    `Contract Balance: ${await ethers.provider.getBalance(
      (
        await ethers.getContract("WrappedToken")
      ).address
    )}`
  )
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
