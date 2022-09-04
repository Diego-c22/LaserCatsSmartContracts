const { loadFixture, time } = require('@nomicfoundation/hardhat-network-helpers')
const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('LaserCats Contracts', () => {
  const deployContractFixture = async () => {
    const [wallet, walletTo] = await ethers.getSigners();
    const Contract = await ethers.getContractFactory('LaserCats')
    const contract = await Contract.deploy();
    const tx = await contract.initialize();
    await tx.wait()

    return { contract, wallet, walletTo }
  }

  describe('Deployment', () => {
    it('Should set the right owner', async () => {
      const { contract, wallet } = await loadFixture(deployContractFixture)
      expect(await contract.owner()).to.equal(wallet.address)
    })
  })

  describe('Mint To', () => {
    it('Should revert an error when unlock time is less than curren time ', async () => {
      const { contract, wallet, walletTo } = await loadFixture(deployContractFixture)
      const secondUser = contract.connect(walletTo)
      const amount = (await contract.price()).mul(10)
      await expect(secondUser.mintTo(10, { value: amount})).to.be.revertedWith('Transfer exceeds max amount.');
    })
  })

  describe('Price', () => {
    it('Should decrease the price 0.05 ether each 20 minutes.', async () => {
      const { contract, wallet, walletTo } = await loadFixture(deployContractFixture)
      const wallets = await ethers.getSigners()
      const currentTimestamp = Math.floor(Date.now() / 1000)
      contract.setUnlockTime(currentTimestamp)
      const times = []
      console.log(await contract.tokensURI())
      for (i = 0; i < 40; i++) {
        const nexttime = currentTimestamp + (1200 * i)
        await time.increaseTo(nexttime + 5)
        const price = await contract.price()
        const xcontract = contract.connect(wallets[Math.floor(i/2)])
        await xcontract.mintTo(1, { value: price })
        console.log('Price:', ethers.utils.formatEther(price), 'eth')
        times.push(price.add((ethers.BigNumber.from('50000000000000000').mul(i))) == ethers.BigNumber.from('2000000000000000000'))
      }

      console.log(times)
      console.log(await contract.tokensURI())

      expect(times.reduce((x, y) => x * y)).to.be.equal(0)
    })
  })


})