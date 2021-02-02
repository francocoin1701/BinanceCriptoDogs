// SPDX-License-Identifier: MIT

pragma solidity >0.5.19 <=0.7.0;

import "./dogAttack.sol";
import "./erc721.sol";
import "./safemath.sol";

contract DogOwnership is DogeAttack, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) dogApprovals;

  function balanceOf(address _owner) public override view returns (uint256 _balance) {
    return ownerDogCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public override view returns (address _owner) {
    return dogToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerDogCount[_to] = ownerDogCount[_to].add(1);
    ownerDogCount[msg.sender] = ownerDogCount[msg.sender].sub(1);
    dogToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) public override onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public override onlyOwnerOf(_tokenId) {
    dogApprovals[_tokenId] = _to;
    emit Approval(msg.sender, _to, _tokenId);
  }

  function takeOwnership(uint256 _tokenId) public override {
    require(dogApprovals[_tokenId] == msg.sender);
    address owner = ownerOf(_tokenId);
    _transfer(owner, msg.sender, _tokenId);
  }
}
