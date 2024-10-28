// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract SupplyChainAccessControl is AccessControl {
    bytes32 public constant MANUFACTURER_ROLE = keccak256("MANUFACTURER_ROLE");
    bytes32 public constant TRANSPORTER_ROLE = keccak256("TRANSPORTER_ROLE");
    bytes32 public constant RETAILER_ROLE = keccak256("RETAILER_ROLE");

     constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleAdmin(MANUFACTURER_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(TRANSPORTER_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(RETAILER_ROLE, DEFAULT_ADMIN_ROLE);
    }

    function grantManufacturerRole(address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(MANUFACTURER_ROLE, account);
    }

    function grantTransporterRole(address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(TRANSPORTER_ROLE, account);
    }

    function grantRetailerRole(address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(RETAILER_ROLE, account);
    }

    function revokeRole(bytes32 role, address account) public override onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(role, account);
    }

    function isAuthorized(address account) public view returns (bool) {
        return hasRole(MANUFACTURER_ROLE, account) ||
               hasRole(TRANSPORTER_ROLE, account) ||
               hasRole(RETAILER_ROLE, account);
    }
} 