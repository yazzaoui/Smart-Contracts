# Smart-Contracts Collection

## sparefund.sol

The idea behind this simple contract is that one can create a saving fund by accumulating spare change when sending money to someone else.
Fund may only be redeemed once per year.
Spare change is computed by rounding up the amount to the next most significant figure with a precision of 1.
Exemple: In order to send 17.8 ETH, 20 ETH are required to perform the transaction and the remaining 2.2 ETH will be saved in your account.

## soccerbet.sol

Gambling smart contract: You can bet some ethers on the next Champion's League soccer game occurring between PSG and Real Madrid.
10% fees reserved to the contract owner.
It is using Oraclize in order to fetch the results from api.football-data.org REST api.
Lazy evaluation in order to release funds and minimize gas consumption.

