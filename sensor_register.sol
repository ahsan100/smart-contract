pragma solidity ^0.4.24;

contract main{
    
    mapping(bytes32 => device) sensorList;
    mapping (address => uint256) balances;
    
    uint256 total_sensor= 0;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    	
	constructor() public {
		balances[msg.sender] = 10000;
	}
	
	struct device{
		string name;
		string sensorID;
		address creator;
		uint256 price;
    	}
    	
	function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		emit Transfer(msg.sender, receiver, amount);
		return true;
	}
	
	function getBalance(address addr) public view returns(uint256) {
		return balances[addr];
	}
	
    function stringToBytes32(string _str) public constant returns (bytes32){
        	bytes memory tempBytes = bytes(_str);
        	bytes32 convertedBytes;
        	if(0 == tempBytes.length){
            		return 0x0;
        }
        	assembly {
           	 convertedBytes := mload(add(_str, 32))
        	}
        	return convertedBytes;
    	}
    
	function methodRegister(string _name, string _sensors, uint256 _price) public {
		bytes32 newKey = stringToBytes32(_name);
		total_sensor = total_sensor + 1;
		sensorList[newKey].name = _name;
		sensorList[newKey].sensorID = _sensors;
		sensorList[newKey].creator = msg.sender;
		sensorList[newKey].price = _price;
    	}
	
	function getPrice(string _name) public constant returns (uint256){
        	bytes32 key = stringToBytes32(_name);
        	uint _price = sensorList[key].price;
        	return _price;
    	}
   
   function getMac(string _name) public constant returns (string){
        	bytes32 key = stringToBytes32(_name);
        	string _mac = sensorList[key].sensorID;
        	return _mac;
    	}
    	
    function getSensors() public constant returns (uint256){
        	return total_sensor;
    	}
	
	function requestData(string _name, uint _time) public returns(bool sufficient) {
        	bytes32 key = stringToBytes32(_name);
        	address _receiver = sensorList[key].creator; 
        	uint _money = sensorList[key].price * _time;
		sendCoin(_receiver, _money);
		return true;
	}
}
