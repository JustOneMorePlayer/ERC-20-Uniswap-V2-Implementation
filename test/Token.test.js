const { assert } = require("chai")
const { getNamedAccounts, deployments, ethers } = require("hardhat")
const { experimentalAddHardhatNetworkMessageTraceHook } = require("hardhat/config")

describe("Token", async function () {
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
    })

    describe("constructor", async function (){{
        it("sets the state", async function () {
            assert.equal("WETH", await WETH.symbol())
            assert.equal("Wrapped Ethereum", await WETH.name())
            assert.equal(0, await WETH.totalSupply())
        })

        it("wraps", async function() {
            const clientStartingBalance = await ethers.provider.getBalance(client.address)
            const contractStartingBalance = await ethers.provider.getBalance(WETH.address)

            const transactionResponse = await WETH.connect(client).wrapEther({value: sendValue})
            const transactionReceipt = await transactionResponse.wait(1)
            const {gasUsed, effectiveGasPrice} = transactionReceipt

            const clientEndingBalance = await ethers.provider.getBalance(client.address)
            const contractEndingBalance = await ethers.provider.getBalance(WETH.address)

            assert.equal(sendValue.toString(), (await WETH.totalSupply()).toString())
            assert.equal(sendValue.toString(), (await WETH.getBalanceOf(client.address)).toString())
            assert.equal(clientEndingBalance.toString(), 
                clientStartingBalance.sub(gasUsed.mul(effectiveGasPrice).toString()).sub(sendValue).toString())
            assert.equal(contractEndingBalance.toString(), sendValue.toString())
            
        })

    }})

})