// SPDX-License-Identifier: MIT

pragma solidity >0.5.19 <=0.7.0;

import "./dogHelper.sol";

contract DogeAttack is DogHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
  }

  function attack(uint _dogId, uint _targetId) external onlyOwnerOf(_dogId) {
    Dog storage myDog = dogs[_dogId];
    Dog storage enemyDog = dogs[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      myDog.winCount++;
      myDog.level++;
      enemyDog.lossCount++;
      feedAndMultiply(_dogId, enemyDog.dna);
    } else {
      myDog.lossCount++;
      enemyDog.winCount++;
      _triggerCooldown(myDog);
    }
  }
}
