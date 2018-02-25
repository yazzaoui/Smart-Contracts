# Smart-Contracts Collection

## sparefund.sol

The idea behind this very simple contract is that one can create a saving fund by accumulating spare change when sending money to someone else.
Fund may only be redeemed once per year.
Spare change is computed by rounding up the amount to the next most significant figure with a precision of 1.

Exemple: In order to send 17.8 ETH to someone, 20 ETH are required from you to perform the transaction and the remaining 2.2 ETH will be saved in your account.

## soccerbet.sol

Gambling smart contract: You can bet some ethers on the next Champion's League soccer game occurring between PSG and Real Madrid.
10% fees reserved for the contract owner.

It is using Oraclize library in order to fetch the results from football-data.org REST api.
Lazy evaluation in order to release funds and minimize gas consumption.

## stabletok.sol

Attempt to create a simple ERC20 stable token. 

My assumptions are : 

 - Equation of exchange can model the token economy.
 - Transaction fees decrease velocity therefore reduces the price level.
 - Token supply increase leads to a price level increase.


The main idea is that the contract can leverage those two antagonistic actions in order to stabilize the price level, avoiding having to deal with negative delta on token supply. In the general case, new supplied tokens will be sold against ethers in an auction market controlled by the contract. The amount of ethers detained by the contract would give some legitimacy to the system but I think it should not affect the price.

 It leads us to two problems:

1) The contract needs to be able to correctly assess its value in USD.
 - It is compulsory for all users to provide the current price by a voting scheme. A failure to do so or a voted value too far from the mean will incur a penality. I believe that a very precise figure is not needed so it shouldn't be a problem to the common user.
 
2) How to correctly determine the parameter changes. 
 - It is not correct to think that when changing money supply or transaction fees this would have a proportionate effect on the price level, therefore the contract needs to dynamically evaluate the weights of those parameter changes, which they might be time-dependant too in the long run.


The voting scheme is not very complicated and is currently being implemented by the contract but the dynamic part is way trickier, but it looks like a closed-loop control system, and I'm currently working on this.





### For any questions, please contact me at : y@azzaoui.fr