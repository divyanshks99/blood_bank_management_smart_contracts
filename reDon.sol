// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BloodBank {
    struct Donor {
        string firstName;
        string dateOfBirth;
        string gender;
        bool feelingWell;
        bool mealRecently;
        bool donatedRecently;
        bool chestyCoughOrSoreThroat;
        bool pregnantOrBreastfeeding;
        bool isEligible;
    }
    
    mapping(address => Donor) public donors;
    
    event DonorRegistered(address indexed donor, string indexed firstName);

    // Step 1: Collect basic information
    function collectBasicInfo(string memory _firstName, string memory _dateOfBirth, string memory _gender) external {
        donors[msg.sender].firstName = _firstName;
        donors[msg.sender].dateOfBirth = _dateOfBirth;
        donors[msg.sender].gender = _gender;
    }

    // Step 2: Perform health assessment
    function performHealthAssessment(bool _feelingWell, bool _mealRecently, bool _donatedRecently, bool _chestyCoughOrSoreThroat, bool _pregnantOrBreastfeeding) external {
        donors[msg.sender].feelingWell = _feelingWell;
        donors[msg.sender].mealRecently = _mealRecently;
        donors[msg.sender].donatedRecently = _donatedRecently;
        donors[msg.sender].chestyCoughOrSoreThroat = _chestyCoughOrSoreThroat;
        donors[msg.sender].pregnantOrBreastfeeding = _pregnantOrBreastfeeding;
    }

    // Step 3: Final registration
    function registerDonor() external {
        require(!donors[msg.sender].chestyCoughOrSoreThroat, "Donor has a chesty cough or sore throat");
        require(!donors[msg.sender].pregnantOrBreastfeeding, "Donor is pregnant or breastfeeding");
        
        donors[msg.sender].isEligible = donors[msg.sender].feelingWell && !donors[msg.sender].mealRecently && !donors[msg.sender].donatedRecently;

        emit DonorRegistered(msg.sender, donors[msg.sender].firstName);
    }
}
s
