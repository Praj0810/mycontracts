pragma solidity ^0.4.0;
contract MyVotingApp{
    //Structure for candidate participating in Election:
    struct Candidate{
        string name;
        uint voteCount;
    }
    //Structure for Voter voting the candidate :
    struct Voter{
        bool authorized;
        bool voted;
        uint voteIndex;
        uint weight;
    }
    
    
    address public contractowner;
    string public ElectionName;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    uint public totalvotes;
    
    //access authorized by contractowner only;
    modifier Access(){
        require(msg.sender == contractowner);
        _;
    }

    constructor(string _name) public{
        contractowner = msg.sender;
        ElectionName = _name;  
    }


    function addCandidate(string candidate1, string candidate2) Access public{
        candidates.push(Candidate(candidate1, 0));
        candidates.push(Candidate(candidate2,0));
    }
    
    function authorize(address voter) Access public {
        require(!voters[voter].voted);
        require(voters[msg.senderz].authorized);
        voters[msg.sender].authorized = true;
        voters[voter].weight = 1;   
    }

    function vote(uint _voteIndex) public{

        require(!voters[msg.sender].voted);
        require(voters[msg.sender].authorized);

        voters[msg.sender].voted = true;
        voters[msg.sender].voteIndex = _voteIndex;

        candidates[_voteIndex].voteCount += voters[msg.sender].weight;

        totalvotes += 1;

    }

    function endElection() public {
        selfdestruct(contractowner);
    }


}