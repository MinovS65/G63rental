// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract G63 {
    address payable public dealer;
    address payable public renter;
    enum Status {Available, Rented}
    Status public currentStatus;

    event Renting(address renter);
    event VehicleReturned(address renter);

    constructor () {
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
        renter = payable(msg.sender);
        renter.transfer(msg.value-5 ether);
        dealer.transfer(5 ether);
        currentStatus = Status.Rented;
        emit Renting(msg.sender);
    }

    function returnVehicle() public {
        require(currentStatus == Status.Rented, "The vehicle is not rented");
        require(msg.sender == renter, "You cannot return the vehicle, you are not the renter!");
        currentStatus = Status.Available;
        emit VehicleReturned(msg.sender);
    }
}