// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract G63 {
    address payable public dealer;
    enum Status {Available, Rented}
    Status public currentStatus;

    constructor() {
        dealer = payable(msg.sender);
        currentStatus = Status.Available;
    }

    modifier onlyWhenAvailable() {
        require(currentStatus == Status.Available, "Not available at the moment");
        _;
    }

    modifier onlyIfYouHaveMoney() {
        require(msg.value >= 5 ether, "Not enough money, the rental of the vehicle costs 5 ether");
        _;
    }

    function transaction() public payable onlyIfYouHaveMoney onlyWhenAvailable {
        currentStatus = Status.Rented;
        if (msg.value>5) {
            dealer.transfer(msg.value-5);
        }
    }

    function returnVehicle() public {
        require(currentStatus == Status.Rented, "The vehicle is not rented");
        currentStatus = Status.Available;
    }

}