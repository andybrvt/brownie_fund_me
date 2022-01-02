// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

// to first import the chainlink conversation function you just have to import it
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";


// safemathchainlink is pretty much the same as safemath

contract FundMe {
    // be able to accept some type of payment

    // using SafeMathChainlink for uint256;

    // remember address is a type
    mapping(address => uint256) public addressToAmountFunded;
    address public owner;
    address[] public funders;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) public{
        priceFeed = AggregatorV3Interface(_priceFeed);
        owner = msg.sender;
    }

    // keep us address that send us value
    function fund() public payable{

        // $50

        uint256 minimumUSD = 50 * 10 ** 18; // this will be in wei


        // require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH");

        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        // so they want to send us $50 and the sender associated with it
        // you can check it

        // what the eth --> usd conversation rate
        // this is where oracale comes in
        // to make this converstion
        // this is where blockchain oracal is need


    }


    // when runing that aggregatev3interface ---> you can use it to have functions
    // that can be used to call different values
    function getVersion() public view returns(uint256){
        // the contract is aggregatorV3interface so that is why it has the function, when you pass in the address
        // of the type of contract you can get that contract and start calling functions in here
        // you are calling another contract in this contract


        // this priceFeed is a contract now that has these functions from the interface
        // you are just usng the interface to see what functions the contract holds
        return priceFeed.version();
    }

    function getPrice() public view returns(uint256){
        // this is used to get the price of the current eth to usd
        (,int256 answer,,,) = priceFeed.latestRoundData();
        // you can put blanks
        // you can return type casting
        // this already returned something in 8 decmial places already for gwei so you standardized
        // it to 18
        // they return this in gwei so you convert it straight to wei
        // 1 gwei = 1*10^10 wei
        // 1 gwei = 1*10^-8
        return uint256(answer * 1000000000);

        // remember it is 8 decimal

    }



    // function to get a value that they send to us dollars
    // the eth amount he put in is in wei
    // to get wei to eth/usd --> pretty much divided by 1*10^18
    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice(); // this function will return the price of eth to us dollars
        uint256 ethAmountInUsd = (ethPrice * ethAmount)/1000000000000000000;
        return ethAmountInUsd; // you can't do decimals in solidity
        // so this return the number you just divid it by 10^18

    }


    modifier onlyOwner{
        // what this function is saying is that you run this require first
        // and then continue where the underscore is
        require(msg.sender == owner);
        _;
    }

    // you need the payable keyword for any function that transfers eth
    function withdraw() payable onlyOwner public{
        // this is anyone can withdraw funds, we want to make it so that it is only admin
        // use require msg.sender = owner
        // sends amount to eth who ever it is being called on

        msg.sender.transfer(address(this).balance);

        for(uint256 funderIndex= 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // make sure when you do new you will do a function call to create it
        funders = new address[](0);
    }

    function getEntranceFee() public view returns (uint256){
      // minimumUSD
      uint256 minimumUSD = 50 * 10**18;
      uint256 price = getPrice(); // get price in wei of eth/usd
      uint256 precision = 1*10**18;
      return (minimumUSD * precision)/price;
      
    }
}
