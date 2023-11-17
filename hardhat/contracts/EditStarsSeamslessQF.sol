// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract QuadraticFunding {
    address public owner;
    
    struct Creator {
        address creatorAddress;
        uint256 fundsRaised;
    }

    struct Donation {
        address donor;
        address creator;
        uint256 amount;
    }

    Creator[] public creators;
    Donation[] public donations;

    uint256 public currentEpoch;
    uint256 public epochEndTime;

    IERC20 public token; // ERC-20 token contract

    mapping(address => uint256) public creatorFunds; // Use a state variable mapping

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier epochEnded() {
        require(block.timestamp > epochEndTime, "Epoch has not ended");
        _;
    }

    constructor() {
        owner = msg.sender;
        currentEpoch = 1;
        epochEndTime = block.timestamp + 1 weeks; // Initial epoch duration is set to 1 week
    }

    function donate(address creator) external payable {
        require(creator != address(0), "Invalid creator address");

        donations.push(Donation({
            donor: msg.sender,
            creator: creator,
            amount: msg.value
        }));
    }

    function distributeFunds() external onlyOwner epochEnded {
        uint256 totalFunds;

        for (uint256 i = 0; i < donations.length; i++) {
            Donation memory donation = donations[i];
            creatorFunds[donation.creator] += donation.amount;
            totalFunds += donation.amount;
        }

        // Distribute funds to creators using quadratic funding algorithm
        for (uint256 i = 0; i < creators.length; i++) {
            Creator storage creator = creators[i];
            uint256 matchingFunds = (creatorFunds[creator.creatorAddress] * creatorFunds[creator.creatorAddress]) / totalFunds;
            creator.fundsRaised += matchingFunds;
        }

        // Send prizes to creators
        for (uint256 i = 0; i < creators.length; i++) {
            Creator storage creator = creators[i];
            if (creator.fundsRaised > 0) {
                token.transfer(creator.creatorAddress, creator.fundsRaised);
                creator.fundsRaised = 0; // Reset fundsRaised for the next epoch
            }
        }

        // Clear donations for the next epoch
        delete donations;

        // Increment the epoch and set the end time for the new epoch
        currentEpoch++;
        epochEndTime = block.timestamp + 1 weeks;
    }

    function getCreatorDetails(uint256 index) external view returns (address, uint256) {
        require(index < creators.length, "Creator index out of bounds");
        Creator storage creator = creators[index];
        return (creator.creatorAddress, creator.fundsRaised);
    }

    function getNumberOfCreators() external view returns (uint256) {
        return creators.length;
    }

    function getCurrentEpoch() external view returns (uint256, uint256) {
        return (currentEpoch, epochEndTime);
    }
}