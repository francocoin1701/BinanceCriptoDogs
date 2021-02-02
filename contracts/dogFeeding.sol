// SPDX-License-Identifier: MIT

pragma solidity >0.5.19 <=0.7.0;


import "./dogFactory.sol";

abstract contract  KittyInterface  {
  function getKitty(uint256 _id) external virtual view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract DogFeeding is DogFactory {

  KittyInterface kittyContract;

  modifier onlyOwnerOf(uint _dogId) {
    require(msg.sender == dogToOwner[_dogId]);
    _;
  }

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Dog storage _dog) internal {
    _dog.readyTime = uint32(block.timestamp + cooldownTime);
  }

  function _isReady(Dog storage _dog) internal view returns (bool) {
      return (_dog.readyTime <= block.timestamp);
  }

  function feedAndMultiply(uint _dogId, uint _targetDna ) internal onlyOwnerOf(_dogId) {
    Dog storage mydog = dogs[_dogId];
    require(_isReady(mydog));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (mydog.dna + _targetDna) / 2;   
    _createDog("NewDog", newDna);
    _triggerCooldown(mydog);
  }

  function feedOnKitty(uint _dogId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_dogId, kittyDna);
  }
}
