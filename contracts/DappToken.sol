pragma solidity ^0.5.0;

contract DappToken {
  // attributes of the token
  string  public name = "DApp Token";
  string  public symbol = "DAPP";
  // total supply of tokens allocated
  uint256 public totalSupply = 1000000000000000000000000; // 1 million tokens
  uint8   public decimals = 18;
  string accName = "Test token";
  uint256 accToken = 0;

  // create our event that will will be emitted when there is a transfer()
  event Transfer(
    address indexed _from,
    address indexed _receiver,
    uint256 _numTokens
  );

  event Approval(
    address indexed _owner,
    address indexed _spender,
    uint256 _numTokens
  );

   // current token of an account identified by the owners address
  mapping(address => uint256) public balanceOf;

  // token allowed to be transfered from an address to owners address.
  mapping(address => mapping(address => uint256)) public allowance;

  // runs right after contract is deployed
  // sets the totalTokens to the accounts of the owner.
  constructor() public {
    balanceOf[msg.sender] = totalSupply;
  }

  function transfer(address _receiver, uint256 _numTokens) public returns (bool success) {
    require( _numTokens <= balanceOf[msg.sender]);
    balanceOf[msg.sender] = balanceOf[msg.sender] - _numTokens;
    balanceOf[_receiver] = balanceOf[_receiver] + _numTokens;
    emit Transfer(msg.sender, _receiver, _numTokens);
    return true;
  }

  function approve(address _spender, uint256 _numTokens) public returns (bool success) {
    // account owner approves spender a number of token to be spent or transfered.
    allowance[msg.sender][_spender] = _numTokens;
    emit Approval(msg.sender, _spender, _numTokens);
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    require(_value <= balanceOf[_from]);
    require(_value <= allowance[_from][msg.sender]);
    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    allowance[_from][msg.sender] -= _value;
    emit Transfer(_from, _to, _value);
    return true;
  }

  function setName(string memory _name) public {
    accName = _name;
  }

  function getAccName() public view returns (string memory) {
    return accName;
  }

  function setAccount(address _newAddress) public {
    accToken = balanceOf[_newAddress];
  }

  function getAcc() public view returns (uint256) {
    return accToken;
  }
}