// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.16;

contract lottery{
    //entities - manager, players and winner
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor(){
        manager=msg.sender;
    }

    //participate for players
    function participate() public payable{
        require(msg.value==1 ether,"Please pay one ether only! ");  //fee to enter the lottery = 1 ether
        players.push(payable(msg.sender));  //to enter if the condition is true
    }
    //check how much ether is present only for manager
        function getBalance() public view returns (uint){
            require(manager==msg.sender,"Sorry, you are not the Manager");
            return address(this).balance;
        }       
    //to create a random function for the lottery - anyone can win the lottery in players

    function random() internal view returns(uint){
        //generates a random number 
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }
    function pickWinner() public{
      require(manager==msg.sender,"You are not the manager");
      require(players.length>=3,"Players are less than 3");

      uint r=random();
      uint index = r%players.length;
      winner=players[index];
      winner.transfer(getBalance());
      players= new address payable[](0); //this will intiliaze the players array back to 0
        }
    }