const { getContractFactory } = require("@nomiclabs/hardhat-ethers/types")
const { assert } = require("chai")
const {deployments, ethers} = require("hardhat")

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
        WETHDeployer = await WETH.connect(deployer)
        await WETHDeployer.wrapEther({value: ethers.utils.parseEther("20")})
        await WETHDeployer.transfer(client.address, ethers.utils.parseEther("20"))

        Token = await ethers.getContract("Token")
        TokenDeployer = await Token.connect(deployer)
        await TokenDeployer.transfer(client.address, ethers.utils.parseEther("40"))

        await deployments.deploy("LiquidityPoolFactory", {
            from: deployer.address,
            contract: "LiquidityPoolFactory",
            args: [WETH.address],
            log: true,
        })

        LiquidityPoolFactory = await ethers.getContract("LiquidityPoolFactory", deployer)
        transactionResponseNewLiquidityPool = await LiquidityPoolFactory.mintNewPool(Token.address)
        transactionReceiptNewLiquidityPool = await transactionResponseNewLiquidityPool.wait()

        LiquidityPoolAddress = transactionReceiptNewLiquidityPool.events[0].args.newLiquidityPoolAddress

        LiquidityPool = await ethers.getContractAt("LiquidityPool", LiquidityPoolAddress)
        LiquidityPoolClient = await LiquidityPool.connect(client)
    })

    it("initializes the pool and swaps", async function () {
        clientInitialWETHBalance = await WETH.getBalanceOf(client.address)
        clientInitialTokenBalance = await Token.getBalanceOf(client.address)

        TokenClient = await Token.connect(client)
        WETHClient = await WETH.connect(client)

        await TokenClient.approve(LiquidityPoolAddress, await TokenClient.getBalanceOf(client.address))
        await WETHClient.approve(LiquidityPoolAddress, await WETHClient.getBalanceOf(client.address))

        await LiquidityPoolClient.initializePool(ethers.utils.parseEther("2"), ethers.utils.parseEther("2"))

        clientEndingWETHBalance = await WETH.getBalanceOf(client.address)
        clientEndingTokenBalance = await Token.getBalanceOf(client.address)

        poolEndingWETHBalance = await WETH.getBalanceOf(LiquidityPoolAddress)
        poolEndingTokenBalance = await Token.getBalanceOf(LiquidityPoolAddress)

        assert.equal((clientInitialWETHBalance.sub(clientEndingWETHBalance)).toString(), poolEndingWETHBalance.toString())
        assert.equal((clientInitialTokenBalance.sub(clientEndingTokenBalance)).toString(), poolEndingTokenBalance.toString())
    

        //SWAP
        console.log("d" + clientEndingWETHBalance.toString())
        console.log(clientEndingTokenBalance.toString())

        console.log((await LiquidityPool.getWETHInTokenPrice()).toString())
        console.log((await LiquidityPool.getTokenInWETHPrice()).toString())

        LiquidityPoolClient.tokenToWETHSwap(ethers.utils.parseEther("1"))

        console.log("d" + (await WETH.getBalanceOf(client.address)).toString())
        console.log((await Token.getBalanceOf(client.address)).toString())
        
        console.log()

        console.log((await LiquidityPool.getWETHInTokenPrice()).toString())
        console.log((await LiquidityPool.getTokenInWETHPrice()).toString())


    })

})