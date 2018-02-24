pragma solidity ^0.4.0;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract SoccerBet is usingOraclize {
    
    enum Result {PSGWIN,REALWIN,EQ}

    struct User {
        uint stake; 
        Result prediction;
    }

    mapping(address => User) users;

    // in order to avoid costly computations:
    uint totalMoney;
    uint[3] money;

    
    // 10% fees for the contract creator
    address owner;
    bool receivedResults;
    Result finalResult;
    bool queryWait;

    bytes32 RealMadridGoalsQuery;
    bool ReceivedRealMadridGoals;
    uint RealMadridsGoals;

    bytes32 PSGGoalsQuery;
    bool ReceivedPSGGoals;
    uint PSGGoals;

    //Miners can manipulate the block timestamp by 900sec .
    //Stay secure by releasing funds only the next day.
    uint date;

    function SoccerBet() public {
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
        assert(2 * oraclize.getPrice("URL") <= msg.value);
        receivedResults = false;
        owner = msg.sender;
        queryWait = false;
        totalMoney = 0;
        money[0] = 0;
        money[1] = 0;
        money[2] = 0;
        date = 1520451000; // Wednesday, March 7, 2018 7:30:00 PM
    }

    function bet(uint _result) public payable {
        assert(now < date);
        assert(users[msg.sender].stake == 0);
        assert(msg.value > 0);
        users[msg.sender].stake = msg.value;
        Result _res =  Result(_result); // should throw exception if not valid
        users[msg.sender].prediction =_res;
        totalMoney += msg.value;
        money[_result] += msg.value;
    }

    function reward() public returns(string result) {
        assert(now > date + 1 days);
        assert(users[msg.sender].stake > 0);
        if(!receivedResults && !queryWait) {
            askOracle();
            return "please wait for the oracle to answer - retry later";
        }
        else if (receivedResults) {
            if(users[msg.sender].prediction == finalResult ) {
                uint _stake = users[msg.sender].stake;
                uint _totalStake = money[uint(users[msg.sender].prediction)];
                uint _amount = (_stake * totalMoney  * 9 ) / ( 100 * _totalStake); // potential integer overflow here if totalMoney > 2^128 (..so not a problem)

                msg.sender.transfer(_amount);
                users[msg.sender].stake = 0;
                return "You won - Congratulation - Your money was transfered";
            }
            else{
                return "You lost";
            }
        }
    }

    function askOracle() internal {
        queryWait = true;
        // JSON parsing is costly - so 2 separates queries here
        RealMadridGoalsQuery = oraclize_query("URL", "json(http://api.football-data.org/v1/fixtures/165140).fixture.result.goalsAwayTeam");
        PSGGoalsQuery = oraclize_query("URL", "json(http://api.football-data.org/v1/fixtures/165140).fixture.result.goalsHomeTeam");
    }

    function __callback(bytes32 _myid, string _result, bytes _proof) {

        if (msg.sender != oraclize_cbAddress()) throw;
        if(_myid == RealMadridGoalsQuery) {
            RealMadridsGoals = parseInt(_result);
            ReceivedRealMadridGoals = true;
        }
        if(_myid == PSGGoalsQuery) {
            PSGGoals = parseInt(_result);
            ReceivedPSGGoals = true;
        }

        receivedResults = ReceivedPSGGoals && ReceivedRealMadridGoals;
        queryWait = !receivedResults;

        if(receivedResults) {
            if(PSGGoals > RealMadridsGoals) {
                finalResult = Result.PSGWIN;
            }
            else if (PSGGoals < RealMadridsGoals) {
                finalResult = Result.REALWIN;
            }
            else {
                finalResult = Result.EQ;
            }
        }
    }
    
    
} 
