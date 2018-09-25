pragma solidity ^0.4.24;

contract main{
    	mapping(bytes32 => device) sensorList;
    	mapping (address => uint256) balances;
    	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	constructor() public {
		balances[msg.sender] = 10000;
	}
	struct device{
		string name;
		string sensor;
		address creator;
		uint price;
		address deviceContract;
		bytes abiDetail;
		string publicKey;
    	}
	function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		Transfer(msg.sender, receiver, amount);
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
	function methodRegister(string _name, string _sensors, address _creator, uint _price, address _deviceContract, bytes _detail, string _publicKey) public {
		bytes32 newKey = stringToBytes32(_name);
		sensorList[newKey].name = _name;
		sensorList[newKey].sensor = _sensors;
		sensorList[newKey].creator = _creator;
		sensorList[newKey].price = _price;
		sensorList[newKey].deviceContract = _deviceContract;
		sensorList[newKey].abiDetail = _detail;
		sensorList[newKey].publicKey = _publicKey;
    	}
    	function getPublicKey(string _name) public constant returns (string _publicKey){
        	bytes32 key = stringToBytes32(_name);
        	_publicKey = sensorList[key].publicKey;
    	}
    	function getDeviceContract(string _name) public constant returns (address _deviceContract){
        	bytes32 key = stringToBytes32(_name);
        	_deviceContract = sensorList[key].deviceContract;
    	}
    	function getContractAbi(string _name) public constant returns (bytes _abi){
        	bytes32 key = stringToBytes32(_name);
        	_abi = sensorList[key].abiDetail;
    	}
	function requestData(string _name, uint _time) public returns(bool sufficient) {
        	bytes32 key = stringToBytes32(_name);
        	address _receiver = sensorList[key].creator; 
        	uint _money = sensorList[key].price * _time;
		sendCoin(_receiver, _money);
		return true;
	}
}
