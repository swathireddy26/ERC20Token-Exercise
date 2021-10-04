const { expect } = require("chai");

describe("Token contract", function () {

  let Token;
  let token;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  
  beforeEach(async function () {
    // Get the ContractFactory and Signers.
    Token = await ethers.getContractFactory("Token");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    token = await Token.deploy();
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await token.owner()).to.equal(owner.address);
    });

    it("Should assign the total supply of tokens to the owner", async function () {
      const ownerBalance = await token.balanceOf(owner.address);
      expect(await token.totalSupply()).to.equal(ownerBalance);
    });
  });

  describe("Transactions", function () {

    it("Mint tokens and check the balance", async function () {
      const initialOwnerBalance = await token.balanceOf(owner.address);
      await token.mint(owner.address, 100);
      const finalOwnerBalance = await token.balanceOf(owner.address);
      expect(finalOwnerBalance).to.equal(+initialOwnerBalance + 100);
    });

    it("Should transfer tokens between accounts", async function () {
      // Transfer 100 tokens from owner to addr1
      await token.transfer(addr1.address, 100);
      const addr1Balance = await token.balanceOf(addr1.address);
      expect(addr1Balance).to.equal(100);

      // Transfer 100 tokens from addr1 to addr2
      // We use .connect(signer) to send a transaction from another account
      await token.connect(addr1).transfer(addr2.address, 100);
      const addr2Balance = await token.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(100);
    });

    it("Should fail if sender doesn’t have enough tokens", async function () {
      const initialOwnerBalance = await token.balanceOf(owner.address);

      // Try to send 1 token from addr1 (0 tokens) to owner.
      // `require` will evaluate false and revert the transaction.
      await expect(
        token.connect(addr1).transfer(owner.address, 1)
      ).to.be.revertedWith("ERC20: Not enough tokens");

      // Owner balance shouldn't have changed.
      expect(await token.balanceOf(owner.address)).to.equal(
        initialOwnerBalance
      );
    });

    it("Should update balances after transfers", async function () {
      const initialOwnerBalance = await token.balanceOf(owner.address);

      // Transfer 100 tokens from owner to addr1.
      await token.transfer(addr1.address, 100);

      // Transfer another 50 tokens from owner to addr2.
      await token.transfer(addr2.address, 50);

      // Check balances.
      const finalOwnerBalance = await token.balanceOf(owner.address);
      expect(finalOwnerBalance).to.equal(initialOwnerBalance - 150);

      const addr1Balance = await token.balanceOf(addr1.address);
      expect(addr1Balance).to.equal(100);

      const addr2Balance = await token.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(50);
    });

    it("Transfer shouldn't happen after pausing ", async function () {
      const initialOwnerBalance = await token.balanceOf(owner.address);
      await token.pause();
      await expect(token.transfer(addr1.address, 100)
      ).to.be.revertedWith("Pausable: paused");

      // Owner balance shouldn't have changed.
      expect(await token.balanceOf(owner.address)).to.equal(
        initialOwnerBalance
      );
    });

    it("Transfer should happen after Unpausing ", async function () {
      const initialOwnerBalance = await token.balanceOf(owner.address);
      await token.pause();
      await token.unpause();
      expect(await token.transfer(addr1.address, 100));
 
      // Owner balance should have changed.
      expect(await token.balanceOf(owner.address)).to.equal(
        initialOwnerBalance - 100
      );
    });
  });
});