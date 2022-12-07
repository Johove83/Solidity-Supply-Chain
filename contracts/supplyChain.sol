pragma solidity ^0.5.0;

contract supplyChain {
    uint32 public pid = 0;    // Product ID
    uint32 public uid = 0;    // User ID
    uint32 public rid = 0;    // Registration ID


    struct product {
        string modelNumber;
        string partNumber;
        string serialNumber;
        address productOwner;
        uint32 cost;
        uint32 mfgTimeStamp;
    }

    mapping(uint32 => product) public products;

    struct participant {
        string userName;
        string password;
        string participantType;
        address participantAddress;
    }

    mapping(uint32 => participant) public participants;

    struct registration {
        uint32 productId;
        uint32 ownerId;
        uint32 trxTimeStamp;
        address productOwner;
    }

    mapping(uint32 => registration) public registration; 

    mapping(uint32 => uint32[]) public productTrack;

    event Transfer(uint32 productId);

    function createParticipant(string _name, string _pass, address _pAdd, string _pType) public returns (uint32) {
        uint32 userId = uid++;
        participants[userId].userName = _name;
        participants[userId].password = _pass;
        participants[userId].participantAddress = _pAdd;
        participants[userId].participantType = _pType;

        return userId;
    }

    function getParticipantDetails(uint32 _pid) public view returns (string, address, string) {
        return (participants[pid].username, participants[pid].participantAddress, participants[pid].participantType);
    }

    function createProduct(uint32 _ownerID, string _modelNumber, string _partNumber, string _serialNumber, uint32 _productCost) public returns (uint32) {
        if(keccak256(abi.encodePacked(participants[_ownerId].participantType)) == keccak256("Manufacturer")) {
            uint32 productId = pid++;

            products[productId].modelNumber = _modelNumber;
            products[productId].partNumber = _partNumber;
            products[productId].serialNumber = _serialNumber;
            products[productId].cost = _productCost;
            products[productId].productOwner = participants[_ownerId].particpantAddress;
            products[productId].mfgTimeStamp = uint32(now);

            return productId;
        }

        return 0;
    }

    function getProductDetails(uint32 _productId) public view returns (string, string, string, uint32, address, uint32) {
        return (products[_productId].modelNumber, products[_productId].partNumber, 
                products[_prodcutId].serialNumber, products[_productId].cost,
                products[_productId].productOwner, products[_productId].mfgTimeStamp);
    }

    function transferToOwner(uint32 _user1Id, uint32 _user2Id, uint32 _prodId) public returns(bool) {
        participant memory p1 = participants[_user1Id];
        participant memory p2 = participants[_user2Id];
        uint32 registration_id = rid++;

        registrations[registration_id].productId = _prodId;
        registrations[registration_id].productOwner = p2.participantAddress;
        registrations[registration_id].ownerId = _user2Id;
        registrations[registration_id].trxTimeStamp = uint32(now);
        products[_prodId].productOwner = p2.participantAddress;
        productTrack[_prodId].push(registration_id);
        emit Transfer(_prodId);

        return (true);
    }

    function getProductTrack(uint32 _prodId) external view returns (uint32[]) {

        return productTrack[_prodId];
    }

    function getRegistrationDetails(uint32 _regId) public view returns (uint32, uint32, address, uint32) {

        registration memory r = registrations[_regId];

        return (r.prodcutId, r.ownerId, r.productOwner, r.trxTimeStamp);
    }
}