const tokenAbi = require("../artifacts/contracts/Token.sol/Token.json");

async function main() {
    const [owner] = await ethers.getSigners();
    const tokenAddress = "0x07F1189d8626a54b475B64F414fCbB17769FAdE8";

    const contract = new ethers.Contract(
        tokenAddress,
        tokenAbi.abi,
        owner
    );

    await contract.mint(owner.address, 1000 * 10**7);
    const ownerBalance = await contract.balanceOf(owner.address);
    console.log("Token smart contract's address:", contract.address);
    console.log("Owner's Balance:", ownerBalance.toString());
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
  });
  