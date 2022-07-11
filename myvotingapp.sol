// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

/****
 *@title A Smart Contract of VoteApp
 *@author Prajakta Mohite
 *@dev Authorized the address votting for Trump or Biden
 *@notice This contract gives the result of the vottingpoll between Trump and Biden
 */
contract MyVotingApp {

    struct Voter {
        bool authorized;
    }

    address public contractowner;
    mapping(address => Voter) public voters;
    mapping(address => bool) alreadyVoted;


    uint256 votesForTrump;
    uint256 votesForBiden;
    uint256 startVote;
    uint256 endVote;

    modifier Access(address _person) {
        require(msg.sender == contractowner, "ownership of contract");
        require(!voters[_person].authorized, "The voters is already Authorized");
        _;
    }

    modifier VoteTime() {
        require(block.timestamp >= startVote, "Voting not started");
        require(block.timestamp <= endVote, "Voting has ended");
        _;
    }

    constructor(uint256 _startVote, uint256 _endVote) {
        require(
            _startVote < _endVote,
            "Start time of vote should be lesser than Endtime"
        );
        contractowner = msg.sender;
        startVote = block.timestamp + _startVote;
        endVote = startVote + _endVote;
    }

    /**
     *@notice This function will authorised the voters
     *@dev Address voters voting for Trump or biden are authorized by the contract owner
     *@param _person This parameter use as a address of different voters
     */
    function authorize(address _person) public Access(_person) {
        voters[_person].authorized = true;
    }


    /**
     *@notice Person Authorized will vote for Trump
     *@dev In this function  voter will vote in the given voting time and check if the voters has already voted
     */
    function VotingforTrump() public VoteTime {
        require(!alreadyVoted[msg.sender], "already voted");
        votesForTrump += 1;
        alreadyVoted[msg.sender] = true;
    }



    /**
     *@notice Person Authorized will vote for Biden
     *@dev Person Authorized will vote for Biden
     */
    function VotingforBiden() public VoteTime {
        require(!alreadyVoted[msg.sender], "already voted");
        votesForBiden += 1;
        alreadyVoted[msg.sender] = true;
    }


    /**
    *@notice This function gives the votes count of the overall votepoll 
    *@dev The Totalvotes of overall Votepoll is being calculated by adding Votes of trump and biden
    *@return totalvotes uint
    */
    function votesCounts() public view returns (uint256) {
        uint256 totalvotes = (votesForTrump + votesForBiden);
        return totalvotes;
    }


    /**
     *@notice This function gives the winner of the votingpoll 
     *@dev This function gives the final result of the winner and the count of votes the Candidate won by
     */
    function VotingWinner() public view returns (string memory, uint256) {
        require(block.timestamp >= endVote, " Voting results not ready");
        if (votesForBiden > votesForTrump) {
            return ("Winner is Biden ", (votesForBiden - votesForTrump));
        } else if (votesForTrump > votesForBiden) {
            return ("Winner is Trump", (votesForTrump - votesForBiden));
        } else {
            return ("Tie", (votesForTrump - votesForBiden));
        }
    }
}
