// SPDX-License-Identifier: MIT

pragma solidity >0.5.19 <=0.7.0;


import "./dogFeeding.sol";

contract DogHelper is DogFeeding {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _dogId) {
    require(dogs[_dogId].level >= _level);
    _;
  }

  

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _dogId) external payable {
    require(msg.value == levelUpFee);
    dogs[_dogId].level++;
  }

  function withdraw(address payable _i) external onlyOwner{
      _i.transfer(address(this).balance);    
  }

  function changeName(uint _dogId, string memory _newName) external aboveLevel(2, _dogId) onlyOwnerOf(_dogId) {
    dogs[_dogId].name = _newName;
  }

  function changeDna(uint _dogId, uint _newDna) external aboveLevel(20, _dogId) onlyOwnerOf(_dogId) {
    dogs[_dogId].dna = _newDna;
  }

  function getDogsByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerDogCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < dogs.length; i++) {
      if (dogToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
