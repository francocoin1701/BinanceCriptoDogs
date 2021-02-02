// SPDX-License-Identifier: MIT

pragma solidity >0.5.19 <=0.7.0;

import "./ownable.sol";
import "./safemath.sol";

contract DogFactory is Ownable {
    using SafeMath for uint256;
    using SafeMath for uint32;
    using SafeMath for uint16;

    event NewDoge(uint zombieId, string name, uint dna);

    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;
    uint256 cooldownTime = 1 days;
    uint256 countId;

    struct Dog {
        string name;
        uint256 dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Dog[] public dogs;

    mapping(uint256 => address) public dogToOwner;
    mapping(address => uint) ownerDogCount;

    function _createDog(string memory _name, uint256 _dna) internal {
        //uint id = dogs.push(Dog(_name, _dna, 1, uint32(block.timestamp + cooldownTime),0,0)) - 1;
        Dog memory dog;
        dog.name = _name;
        dog.dna = _dna;
        dog.level = 1;
        dog.readyTime = uint32(block.timestamp + cooldownTime);
        dog.winCount = 0;
        dog.lossCount = 0;
        dogs.push(dog);
        uint id = countId + _dna + block.timestamp;       
        dogToOwner[id] = msg.sender;
        ownerDogCount[msg.sender].add(1);
        emit NewDoge(id, _name, _dna);
        countId.add(1);
    }

    function _generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomDog(string memory _name) public {
        require(ownerDogCount[msg.sender] == 0);
        uint256 randDna = _generateRandomDna(_name);
        randDna = randDna - (randDna % 100);
        _createDog(_name, randDna);
    }
}
