# Smart-Contracts Collection

## sparefund.sol

The idea behind this simple contract is that one can create a saving fund by accumulating spare change when sending money to someone else.
Fund may only be redeemed once per year.
Spare change is computed by rounding up the amount to the next most significant figure with a precision of 1.

Exemple: In order to send 17.8 ETH to someone, 20 ETH are required to perform the transaction and the remaining 2.2 ETH will be saved in your account.

## soccerbet.sol

Gambling smart contract: You can bet some ethers on the next Champion's League soccer game occurring between PSG and Real Madrid.
10% fees reserved for the contract owner.

It is using Oraclize library in order to fetch the results from football-data.org REST api.
Lazy evaluation in order to release funds and minimize gas consumption.

## stabletok.sol

Attempt to create a simple ERC20 stable token. 

My ideas are : 

 - Equation of exchange can model the token economy and transaction fees impact velocity.
 - Deterministic new token supply at the rate of +5% per year, imitating world GDP growth.
 - New supplied tokens can only be bought with ethers in an auction market controlled by the contract therefore token's value is known by the contract.
 - Transaction fee will be dynamically adjusted depending on accessed token's value.

This logic is currently implemented by the contract, but I think it need however a separate booting phase because transaction fee can't be negative.





### For any questions, please contact me at : y@azzaoui.fr