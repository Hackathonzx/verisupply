// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SupplyChainAccessControl.sol";

contract ProductTracking is SupplyChainAccessControl {
    struct Product {
        uint productId;
        string name;
        address origin;
        address currentHolder;
        string status;
        int temperature;
        int latitude;
        int longitude;
        uint lastUpdateTime;
        bytes32 qrHash;
    }

    struct Transaction {
        string status;
        address location;
        int temperature;
        int latitude;
        int longitude;
        uint timestamp;
    }

    uint constant public INACTIVITY_THRESHOLD = 3 days;
    
    mapping(uint => Product) private products;
    mapping(uint => Transaction[]) private productHistory;
    mapping(uint => bool) public alerts;

    event ProductRegistered(uint productId, address origin, uint timestamp);
    event StatusUpdated(uint productId, string status, address location, int temperature, int latitude, int longitude, uint timestamp);
    event ProductAlert(uint productId, string alertMessage);
    event AlertReset(uint productId);

    constructor() SupplyChainAccessControl() {}

    modifier onlyAuthorized() {
        require(isAuthorized(msg.sender), "Not authorized to update status.");
        _;
    }

    function registerProduct(uint productId, string memory name, bytes32 qrHash) public onlyRole(MANUFACTURER_ROLE) {
        require(products[productId].productId == 0, "Product already registered.");

        products[productId] = Product({
            productId: productId,
            name: name,
            origin: msg.sender,
            currentHolder: msg.sender,
            status: "Manufactured",
            temperature: 0,
            latitude: 0,
            longitude: 0,
            lastUpdateTime: block.timestamp,
            qrHash: qrHash
        });

        emit ProductRegistered(productId, msg.sender, block.timestamp);
    }

    function updateStatus(uint productId, string memory status, int temperature, int latitude, int longitude) public onlyAuthorized {
        require(products[productId].productId != 0, "Product not registered.");
        
        // Check for inactivity before updating
        if (block.timestamp - products[productId].lastUpdateTime > INACTIVITY_THRESHOLD) {
            alerts[productId] = true;
            emit ProductAlert(productId, "Product inactive for over 3 days.");
        }

        products[productId].currentHolder = msg.sender;
        products[productId].status = status;
        products[productId].temperature = temperature;
        products[productId].latitude = latitude;
        products[productId].longitude = longitude;
        products[productId].lastUpdateTime = block.timestamp;

        productHistory[productId].push(Transaction({
            status: status,
            location: msg.sender,
            temperature: temperature,
            latitude: latitude,
            longitude: longitude,
            timestamp: block.timestamp
        }));

        emit StatusUpdated(productId, status, msg.sender, temperature, latitude, longitude, block.timestamp);
    }

    function checkInactivity(uint productId) public view returns (bool) {
        require(products[productId].productId != 0, "Product not registered.");
        return (block.timestamp - products[productId].lastUpdateTime) > INACTIVITY_THRESHOLD;
    }

    function getProductDetails(uint productId) public view returns (Product memory) {
        require(products[productId].productId != 0, "Product not registered.");
        return products[productId];
    }

    function getProductHistory(uint productId) public view returns (Transaction[] memory) {
        require(products[productId].productId != 0, "Product not registered.");
        return productHistory[productId];
    }

    function verifyProductQR(uint productId, bytes32 qrHash) public view returns (bool) {
        require(products[productId].productId != 0, "Product not registered.");
        return products[productId].qrHash == qrHash;
    }

    function resetAlert(uint productId) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not an admin");
        require(products[productId].productId != 0, "Product not registered.");
        alerts[productId] = false;
        emit AlertReset(productId);
    }
}