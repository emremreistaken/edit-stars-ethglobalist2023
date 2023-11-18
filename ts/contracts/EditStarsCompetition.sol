// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/IPUSHCommInterface.sol";


contract EditStarsCompetition {
    address public owner;
    address internal immutable _pushAddress;
    address internal _pushChannelCreator = 0xBeAD3E8557a507e6b2F293b150Fd2A587a18E47f;
    
    enum CompetitionStatus { Active, Completed } //can add pending state 
    
    struct Competition {
        address organizer;
        string name;
        uint256 prizeAmount;
        address prizeToken;
        uint256 startTime;
        uint256 endTime;
        CompetitionStatus status;
    }

    Competition[] public competitions;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier competitionExists(uint256 competitionId) {
        require(competitionId < competitions.length, "Competition does not exist");
        _;
    }

    modifier competitionNotActive(uint256 competitionId) {
        require(competitions[competitionId].status != CompetitionStatus.Active, "Competition is still active");
        _;
    }

    modifier competitionIsActive(uint256 competitionId) {
        require(competitions[competitionId].status == CompetitionStatus.Active, "Competition is not active");
        _;
    }

    constructor(address push) {
        owner = msg.sender;
        _pushAddress = push;
    }

    function createCompetition(string memory _name, uint256 _prizeAmount, address _prizeToken) external onlyOwner {
        require(_prizeAmount > 0, "Prize amount must be greater than 0");
        require(_prizeToken != address(0), "Invalid prize token address");

        Competition memory newCompetition = Competition({
            organizer: msg.sender,
            name: _name,
            prizeAmount: _prizeAmount,
            prizeToken: _prizeToken,
            startTime: block.timestamp,
            endTime: block.timestamp + 30 minutes,
            status: CompetitionStatus.Active
        });

        competitions.push(newCompetition);

        IPUSHCommInterface(_pushAddress).sendNotification(
            _pushChannelCreator, // from channel,
            address(this), // to recipient, put address(this) in case you want Broadcast or Subset. For Targetted put the address to which you want to send
            bytes(
                string(
                    // We are passing identity here: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/identity/payload-identity-implementations
                    abi.encodePacked(
                        "0", // this is notification identity: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/identity/payload-identity-implementations
                        "+", // segregator
                        "1", // this is payload type: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/payload (1, 3 or 4) = (Broadcast, targetted or subset)
                        "+", // segregator
                        "Edit Stars New Competition Alert!",
                        "+", // segregator
                        _name,
                        ". Check the prizes now!"
                    )
                )
        )
        );
    }

    /*
    function startCompetition(uint256 competitionId) external onlyOwner competitionExists(competitionId) competitionNotActive(competitionId) {
        competitions[competitionId].status = CompetitionStatus.Active;
    }
    */

    function completeCompetition(uint256 competitionId) external onlyOwner competitionExists(competitionId) competitionIsActive(competitionId) {
        competitions[competitionId].status = CompetitionStatus.Completed;
    }

    function claimPrize(uint256 competitionId, address[] calldata winners) external competitionExists(competitionId) competitionNotActive(competitionId){
        Competition storage competition = competitions[competitionId];
        require(competition.status == CompetitionStatus.Completed, "Competition is not completed");

        // For simplicity, transfer the prize amount directly to each winner
        IERC20 token = IERC20(competition.prizeToken);
        uint256 prizePerWinner = competition.prizeAmount / winners.length;

        for (uint256 i = 0; i < winners.length; i++) {
            require(winners[i] != address(0), "Invalid winner address");
            require(token.transfer(winners[i], prizePerWinner), "Prize transfer failed");
        }
    }

    function getCompetitionDetails(uint256 competitionId) external view competitionExists(competitionId) returns (Competition memory) {
        return competitions[competitionId];
    }

    function getNumberOfCompetitions() external view returns (uint256) {
        return competitions.length;
    }
}