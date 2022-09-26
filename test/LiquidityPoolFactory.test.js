const {deployments} = require("hardhat")

describe("LiquidityPool", async function () {
    let accounts
    let deployer, client
    let sendValue
    beforeEach(async function () {
        accounts = await ethers.getSigners()
        deployer = accounts[0]
        client = accounts[1]

        sendValue = ethers.utils.parseEther("1")

        await deployments.fixture()
        WETH = await ethers.getContract("WETHToken")

        await deployments.deploy("LiquidityPoolFactory", {
            from: deployer.address,
            contract: "LiquidityPoolFactory",
            args: [WETH.address],
            log: true,
        })

    })

    it("d", async function () {
    })

})