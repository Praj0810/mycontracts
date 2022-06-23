// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
contract MyVotingApp{
    //Structure for candidate participating in Election:
    struct Candidate{
        string name;
        uint voteCount;
    }
    //Structure for Voter voting the candidate :
    struct Voter{
        bool authorized;
        uint voteIndex;
    }
    
    address public contractowner;
    mapping(address => bool) alreadyVoted;
    
    uint voteForTrump;
    uint voteForBiden;
    //uint totalvotes;
    uint startVote;
    uint endVote;
    

    //access authorized by contractowner only;
    // modifier Access(){
    //     require(msg.sender == contractowner);
    //     _;
    // }

    constructor(uint _startVote, uint _endVote) {
        require(_startVote < _endVote,"Start time of vote should be lesser than Endtime");
        contractowner = msg.sender;
        startVote = block.timestamp + _startVote; 
        endVote = startVote + _endVote;
    }

    // function authorize(address voter) Access public {
    //     require(!voters[voter].voted,"Voter already voted");
    //     require(voters[voter].authorized, "Already authorized");
    //     voters[msg.sender].authorized = true;
    //     voters[voter].weight = 1;   
    // }

    
    function VotingforTrump() public {
        require(block.timestamp >= startVote,"Voting not started");
        require(block.timestamp <= endVote, "Voting has ended");
        require(!alreadyVoted[msg.sender],"already voted");
        voteForTrump += 1;
        alreadyVoted[msg.sender]= true;
    
   }

    function VotingforBiden() public {
        require(block.timestamp >= startVote,"Voting not started");
        require(block.timestamp <= endVote, "Voting has ended");
        require(!alreadyVoted[msg.sender],"already voted");
        voteForBiden += 1;
        alreadyVoted[msg.sender]= true;
   }
    
    function votesCounts() view public returns(uint TotalCount){
       uint totalvotes = (voteForTrump + voteForBiden);
       return totalvotes;
   }


     function VotingWinner() public view returns(string memory Win , uint byVote ){
        require(block.timestamp >= endVote, " Voting results not visible");
        if( voteForBiden > voteForTrump){
            return ("Winner is Biden ", (voteForBiden - voteForTrump));
        }
        else if (voteForTrump > voteForBiden){
            return ("Winner is Trump",(voteForTrump - voteForBiden));
        }
        else if (voteForTrump == voteForBiden){
            return ("Tie",(voteForTrump - voteForBiden));
        }

    }


}