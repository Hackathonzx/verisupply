## Supply Chain Tracking System

# Overview
The Supply Chain Tracking System is a blockchain-based application designed to bring transparency, security, and traceability to product movement across the supply chain. This system leverages role-based access control (RBAC) to ensure that only authorized parties (manufacturer, transporter, retailer) can interact with products as they move from origin to destination. Additionally, it includes alert mechanisms for inactivity, location tracking, and QR code-based authentication, enabling real-time status updates and secure product verification.

**Key Features**
- Role-Based Access Control: Only authorized users can register, update, or verify product details.
- Real-Time Status Tracking: Provides up-to-date product status, including GPS location and temperature monitoring.
- QR Code Verification: Supports QR-based product verification to ensure authenticity.
- Alert System: Notifies stakeholders if a product remains inactive for over three days, adding a layer of accountability.

**Contract Structure**
The project consists of two core Solidity contracts:
- SupplyChainAccessControl: Manages roles and permissions for the manufacturer, transporter, retailer, and admin. Only authorized users are allowed to interact with product data.

- ProductTracking: Extends SupplyChainAccessControl to register products, update product status, and manage alerts.

**SupplyChainAccessControl.sol**
- Defines roles for different stakeholders (MANUFACTURER_ROLE, TRANSPORTER_ROLE, and RETAILER_ROLE) and assigns an admin role for role management.
- Only accounts with specific roles can perform certain functions in the ProductTracking contract.

**ProductTracking.sol**
- Allows manufacturers to register products with details like product name, origin, and a QR hash for authentication.
- Enables authorized parties to update product status, including GPS location, temperature, and condition.
- Maintains a product history log for traceability and verification.
- Integrates an alert system for products inactive beyond a set duration.

# Installation and Setup
Prerequisites
- Node.js and npm (for package management)
- Hardhat (development environment for Ethereum software)
- OpenZeppelin Contracts (for role-based access control)

**Steps**
- Clone the Repository:
git clone https://github.com/Hackathonzx/verisupply.git

cd verisupply

**Install Dependencies:**
- npm install

Compile the Contracts:
- npx hardhat compile

Run Tests:
- npx hardhat test

**Contract Deployment**
Deploy Contracts:
npx hardhat run ignition/modules/deploy.js --network AIATestnet

SupplyChainAccessControl deployed to: 0x7c9D4E3769FD085566de1DB20E5703D3Ec50d37f
Block explorer: https://www.aiascan.com/address/0x7c9D4E3769FD085566de1DB20E5703D3Ec50d37f

ProductTracking deployed to: 0xe34c86A03F17E29F77beeE7c898Adae4dD578006
Block explorer: https://www.aiascan.com/address/0xe34c86A03F17E29F77beeE7c898Adae4dD578006
 

**Usage Guide**
Interacting with the Contract
- Register a Product (only Manufacturer role):
await productTracking.connect(manufacturer).registerProduct(
    1,
    "Product Name",
    ethers.encodeBytes32String("QR_HASH")
);

- Update Product Status (authorized roles):
await productTracking.connect(transporter).updateStatus(
    1,
    "In Transit",
    30, // Temperature
    12345, // Latitude
    67890 // Longitude
);

- Check Product Details:
const product = await productTracking.getProductDetails(1);
console.log(product);

- Verify QR Code:
const isVerified = await productTracking.verifyProductQR(1, ethers.encodeBytes32String("QR_HASH"));
console.log(isVerified); // Returns true if verified

- Alert Reset (Admin Only):
await productTracking.connect(owner).resetAlert(1);
Roles and Permissions
Roles can only be granted by the admin account:

- Grant Manufacturer Role:
await productTracking.grantManufacturerRole(manufacturer.address);

- Grant Transporter Role:
await productTracking.grantTransporterRole(transporter.address);

- Grant Retailer Role:
await productTracking.grantRetailerRole(retailer.address);

**Testing**
The project includes comprehensive test cases covering all major functionalities:

Product Registration: Ensures only manufacturers can register products.
Product Status Update: Checks authorized updates to product status, including temperature and location.
Role-Based Access Control: Verifies restricted access for unauthorized users.
Alert System: Tests inactivity-based alerts and admin reset functionality.
QR Code Verification: Confirms that QR code hashes are correctly verified.

Run the tests with:
- npx hardhat test

Example test output:
    Supply Chain Tracking System
ProductTracking deployed at: 0x5FbDB2315678afecb367f032d93F642f64180aa3
    ✔ should allow a manufacturer to register a product (70ms)
ProductTracking deployed at: 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9
    ✔ should allow authorized parties to update product status (59ms)
ProductTracking deployed at: 0x2279B7A0a67DB372996a5FaB50D91eAA73d2eBe6
    ✔ should restrict unauthorized parties from updating product status (62ms)
ProductTracking deployed at: 0xA51c1fc2f0D1a1b8494Ed1FE312d7C3a78Ed91C0
    ✔ should log product history correctly on status updates (63ms)
ProductTracking deployed at: 0x959922bE3CAee4b8Cd9a407cc3ac1C251C2007B1
    ✔ should allow verifying a product's QR code
ProductTracking deployed at: 0xc6e7DF5E7b4f2A278906862b61205850344D4e7d
    ✔ should trigger an alert if the product is inactive for over 3 days
ProductTracking deployed at: 0xa85233C63b9Ee964Add6F2cffe00Fd84eb32338f
    ✔ should allow admin to reset alerts (39ms)
ProductTracking deployed at: 0x67d269191c92Caf3cD7723F116c85e6E9bf55933
    ✔ should not allow non-admin to reset alerts


  8 passing (3s)


**Additional Notes**
- Security: Only authorized accounts can interact with critical functions. Unauthorized attempts trigger an error.
- Dependencies: The project uses OpenZeppelin’s AccessControl for secure role management.
- Gas Optimization: The contracts are optimized for gas efficiency by reusing role checks and minimizing state changes.

# License
This project is licensed under the MIT License.
