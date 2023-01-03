//SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";

error FortuneCookie__AlreadyFavorited();
error FortuneCookie__NotFavorited();

contract FortuneCookie is Ownable {
  Fortune[] public fortunes;
  struct Fortune {
    string fortune;
    uint40 timestamp;
    uint40 id;
    bool favorite;
  }

  // I think this should make the user the owner instead of the FortuneCookieFactory
  constructor() {
    transferOwnership(tx.origin);
  }

  function shareFortune(
    string memory fortune
  ) public onlyOwner returns (uint40) {
    Fortune memory cookie = Fortune(
      fortune,
      uint40(block.timestamp),
      uint40(fortunes.length),
      false
    );
    fortunes.push(cookie);
    return (cookie.id);
  }

  function edit(uint id, string memory revision) public onlyOwner {
    fortunes[id].fortune = revision;
  }

  function favorite(uint40 id) public onlyOwner {
    if (fortunes[id].favorite == true) {
      revert FortuneCookie__AlreadyFavorited();
    } else {
      fortunes[id].favorite = true;
    }
  }

  function unfavorite(uint id) public onlyOwner {
    if (fortunes[id].favorite == false) {
      revert FortuneCookie__NotFavorited();
    } else {
      fortunes[id].favorite = false;
    }
  }

  // View/pure
  function viewFavorites() public view returns (uint[] memory) {
    uint40 numOfFavorites;
    for (uint i = 0; i <= fortunes.length; i++) {
      if (fortunes[i].favorite == true) {
        numOfFavorites++;
      }
    }
    uint40[] memory favorites = new uint40[](numOfFavorites);
    for (uint i = 0; i <= fortunes.length; i++) {
      if (fortunes[i].favorite == true) {
        favorites[0] = fortunes[i].id;
      }
    }
  }
}
