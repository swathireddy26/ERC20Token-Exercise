async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const Token = await ethers.getContractFactory("Token");
    const token = await Token.deploy();
  
    console.log("Token Smart Contract address:", token.address);
    console.log("Owner's Thali Balance:", (await token.balanceOf(deployer.address)).toString());

    const Stake = await ethers.getContractFactory("Stakeable");
    const stake = await Stake.deploy(token.address);
    console.log("Stakeable Smart Contract address:", stake.address);       
    console.log("Stakeable Smart Contract Balance:", (await token.balanceOf(stake.address)).toString());                                      
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });