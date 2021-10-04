const { expect } = require("chai");

describe("Stakeable contract", function () {

  let Token;
  let _token;
  let Stake;
  let _stake;
  let owner;
  let addr1;
  
  beforeEach(async function () {
    Token = await ethers.getContractFactory("Token");
    [owner, addr1] = await ethers.getSigners();
    _token = await Token.deploy();
    Stake = await ethers.getContractFactory("Stakeable");
    _stake = await Stake.deploy(_token.address);
  });

  describe("Staking", function () {
    it("Should fail if user stakes 0", async function () {
        await _token.transfer(addr1.address, 200);
        await _token.connect(addr1).approve(_stake.address, 200);
        await expect(_stake.connect(addr1).stake(0)
        ).to.be.revertedWith("Staking: Cannot stake nothing");
    });

    it("Should fail if user stakes more than he has", async function () {
        await _token.transfer(addr1.address, 200);
        await _token.connect(addr1).approve(_stake.address, 200);
        await expect(_stake.connect(addr1).stake(300)
        ).to.be.revertedWith("Staking: Cannot stake more than what user has");
    });

    it("Stake tokens and check the balance of smart contract", async function () {
        const initialContractBalance = await _token.balanceOf(_stake.address);
        await _token.transfer(addr1.address, 200);
        await _token.connect(addr1).approve(_stake.address, 200);
        await _stake.connect(addr1).stake(100);
        const finalContractBalance = await _token.balanceOf(_stake.address);
        const result = +initialContractBalance + 100;
        expect(finalContractBalance).to.equal(result);
    });

    it("Should fail if user unstake before the lockin time expiry", async function () {
        await _token.transfer(addr1.address, 200);
        await _token.connect(addr1).approve(_stake.address, 200);
        await _stake.connect(addr1).stake(100);
        await expect(_stake.connect(addr1).unstake(100)
        ).to.be.revertedWith("Staking: Withdraw only after expiry of lockin period");
    });

    it("Should fail if user unstakes more than the staked amount", async function () {
        await _token.transfer(addr1.address, 200);
        await _token.connect(addr1).approve(_stake.address, 200);
        await _stake.connect(addr1).stake(100);
        await expect(_stake.connect(addr1).unstake(200)
        ).to.be.revertedWith("Staking: Cannot withdraw more than you have staked");
    });

    it("Trying to calculate fee", async function () {
      const ownerBalance = await _token.balanceOf(owner.address);
      await _token.approve(_stake.address, 10000);
      await _stake.stake(10000);
      expect(await _token.balanceOf(_stake.address)).to.equal(10000);
      expect(await _stake.total_fee()).to.equal((10000*2)/1000);
    });

    it("should be able to set treasury address", async function () {
      await _stake.setTreasury(owner.address);
      expect(await _stake.treasury()).to.equal(owner.address);
    });

    it("should be able to collect fee", async function () {
      await _token.transfer(addr1.address, 1000);
      const ownerBalance = await _token.balanceOf(owner.address);
      await _token.connect(addr1).approve(_stake.address, 1000);
      await _stake.setTreasury(owner.address);
      await _stake.connect(addr1).stake(1000);
      await _stake.collectFee();
      expect(await _token.balanceOf(owner.address)).to.equal(9999999002);
    })
  });
});