# ERC20Token-Exercise

1. Created a Token contract which mints and transfers tokens between wallets with pausable access control
2. Created a Stakeable contract which allows user to stake and unstake tokens with the following conditions: <br /> 
i) User cannot withdraw tokens within the time lock of 2 hours <br /> 
ii) 0.2% of fee will be sent to the treasury of the contract in every deposit
3. Coveragae is tested through Stakeable_test and Token_test


**Potential Threats to token interaction:**
1. Overflow and Underflow vulnerabilities : Used Safe Math library of Openzeppelin to avoid this
2. Unproteced function vulnerabilities : Used Ownable of Openzeppelin to restrict access









  
