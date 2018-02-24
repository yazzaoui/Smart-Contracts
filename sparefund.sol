pragma solidity ^0.4.0;
contract SpareChangeFund {

    // Storage space is virtually initialized to 0.
    struct User {
        uint balance; //uint is uint256
        uint retrieveDate; // when the user can get back its fund
        bool created;
    }

    mapping(address => User) users;

    modifier userExist {
        require(users[msg.sender].created == true);
        _;
    }
    
    //Need to be called first
    function createUserFund() public payable {
        require(users[msg.sender].created == false);
        users[msg.sender].retrieveDate = now + 1 years;
        users[msg.sender].balance = msg.value;
        users[msg.sender].created = true;
    }

    function retrieveFund() public userExist returns (bool success) { //can be called once per year
        if(now >= users[msg.sender].retrieveDate){
            msg.sender.transfer(users[msg.sender].balance);
            users[msg.sender].balance = 0;
            users[msg.sender].retrieveDate = now + 1 years;
            return true;
        }
        else{
            return false;
        }
    }

  function computeMinSentValue(uint _sAmount) internal pure returns (uint minAmount){
        require(_sAmount > 0);
        uint _amount = _sAmount;
        uint _i = 0;
        bool _roundIt = false;
        while(_amount >= 10){
            if(_amount % 10 != 0){
                _roundIt = true;
            }
            _amount = _amount / 10;
            _i += 1;
        }
        if(_roundIt){
            return (_amount + 1) * 10 ** _i;
        }
        else{
            return _sAmount;
        }
    }
    
    function payTo(address _recipient, uint _amount) public payable userExist returns (bool success){
        uint _minAmount = computeMinSentValue(_amount);
        if(msg.value >= _minAmount){
            _recipient.transfer(_amount);
            users[msg.sender].balance += msg.value - _amount;
            return true;
        }
        else{
            return false;
        }
    }
    
}