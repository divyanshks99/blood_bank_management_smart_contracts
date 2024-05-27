// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BloodBank {
    address public admin;
    
    enum RequesterType { Regular, Hospital }
    
    struct Requester {
        string name;
        string contactAddress;
        string hospitalPhoneNo;
        string hospitalEmail;
        string doctorMobileNo;
        string hospitalID;
        RequesterType requesterType;
        bool isVerified;
        uint registrationTimestamp;
        string referringDoctor;
        uint[] pastRequests;
    }
    
    mapping(address => Requester) public requesters;
    
    event RequesterRegistered(address indexed requester, string indexed name);
    event RequesterVerified(address indexed requester);
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }
    
    modifier onlyRegularRequester() {
        require(requesters[msg.sender].requesterType == RequesterType.Regular, "Only regular requester can call this function");
        _;
    }
    
    modifier onlyHospitalRequester() {
        require(requesters[msg.sender].requesterType == RequesterType.Hospital, "Only hospital requester can call this function");
        _;
    }
    
    constructor() {
        admin = msg.sender;
    }
    
    function registerRequesterType(RequesterType _requesterType) public onlyRegularRequester {
        require(requesters[msg.sender].requesterType == RequesterType.Regular, "Requester type already set");
        
        if (_requesterType == RequesterType.Regular) {
            // Regular requester type selected
        } else if (_requesterType == RequesterType.Hospital) {
            // Hospital requester type selected
            requesters[msg.sender].requesterType = RequesterType.Hospital;
        }
    }

    function collectRegularRequesterInfo(
        string memory _name,
        string memory _contactAddress,
        string memory _doctorMobileNo,
        string memory _referringDoctor,
        string memory _hospitalPhoneNo,
        string memory _hospitalEmail
    ) external onlyRegularRequester {
        // Collect information for regular requester
        Requester storage requester = requesters[msg.sender];
        requester.name = _name;
        requester.contactAddress = _contactAddress;
        requester.doctorMobileNo = _doctorMobileNo;
        requester.referringDoctor = _referringDoctor;
        requester.hospitalPhoneNo = _hospitalPhoneNo;
        requester.hospitalEmail = _hospitalEmail;
        emit RequesterRegistered(msg.sender, _name);
    }

    function collectHospitalID(string memory _hospitalID) external onlyHospitalRequester {
        require(bytes(requesters[msg.sender].hospitalID).length == 0, "Hospital ID already provided");
        requesters[msg.sender].hospitalID = _hospitalID;
    }
    
    function verifyRequester(address _requester) external onlyAdmin {
        // Verify requester
        requesters[_requester].isVerified = true;
        emit RequesterVerified(_requester);
    }
    
    // Function to allow a requester to retrieve their own data
    function getMyData() external view returns (
        string memory name,
        string memory contactAddress,
        string memory hospitalPhoneNo,
        string memory hospitalEmail,
        string memory doctorMobileNo,
        string memory hospitalID,
        RequesterType requesterType,
        bool isVerified,
        uint registrationTimestamp,
        string memory referringDoctor
    ) {
        Requester memory requester = requesters[msg.sender];
        return (
            requester.name,
            requester.contactAddress,
            requester.hospitalPhoneNo,
            requester.hospitalEmail,
            requester.doctorMobileNo,
            requester.hospitalID,
            requester.requesterType,
            requester.isVerified,
            requester.registrationTimestamp,
            requester.referringDoctor
        );
    }
}

