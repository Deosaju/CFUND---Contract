// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract MyContract {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 balance;
        string image;
        address[] donators;
        uint256[] donations;
    }
    mapping(uint256 => Campaign) public campaigns;

    uint256 public campaignCount = 0;

    function CreateCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        Campaign storage campaign = campaigns[campaignCount];

        //is everthing ok?
        require(
            campaign.deadline < block.timestamp,
            "Deadline should be in the future"
        );

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.image = _image;
        campaignCount++;
        return campaignCount - 1;
    }

    function DonateCampaign(uint _id) public payable {
        uint amount = msg.value;
        Campaign storage campaign = campaigns[_id];
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);
        (bool sent,) = payable(campaign.owner).call{value: amount}("");
        if(sent){
            campaign.balance = campaign.balance + amount;
        }

    }

    function GetDonators(uint _id) view public returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }
    function GetCampaigns()  public view returns (Campaign[] memory) {
        Campaign[] memory allCampains = new Campaign[](campaignCount);
        for (uint i = 0; i < campaignCount; i++) {
            Campaign storage item = campaigns[i];

            allCampains[i] = item;  
        }
        return allCampains;
    }
}
