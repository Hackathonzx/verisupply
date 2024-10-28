# Supply Chain Tracking System

# Overview
The Supply Chain Tracking System is a blockchain-based application designed to bring transparency, security, and traceability to product movement across the supply chain. This system leverages role-based access control (RBAC) to ensure that only authorized parties (manufacturer, transporter, retailer) can interact with products as they move from origin to destination. Additionally, it includes alert mechanisms for inactivity, location tracking, and QR code-based authentication, enabling real-time status updates and secure product verification.

# Key Features
- Role-Based Access Control: Only authorized users can register, update, or verify product details.
- Real-Time Status Tracking: Provides up-to-date product status, including GPS location and temperature monitoring.
- QR Code Verification: Supports QR-based product verification to ensure authenticity.
- Alert System: Notifies stakeholders if a product remains inactive for over three days, adding a layer of accountability.

# Contract Structure

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

# Contract Deployment

Deploy Contracts:

npx hardhat run ignition/modules/deploy.js --network AIATestnet
- SupplyChainAccessControl deployed to: 0x7c9D4E3769FD085566de1DB20E5703D3Ec50d37f

Block explorer: https://www.aiascan.com/address/0x7c9D4E3769FD085566de1DB20E5703D3Ec50d37f

- ProductTracking deployed to: 0xe34c86A03F17E29F77beeE7c898Adae4dD578006

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

# Testing

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

    ✔ should allow a manufacturer to register a product (70ms)

    ✔ should allow authorized parties to update product status (59ms)

    ✔ should restrict unauthorized parties from updating product status (62ms)

    ✔ should log product history correctly on status updates (63ms)

    ✔ should allow verifying a product's QR code

    ✔ should trigger an alert if the product is inactive for over 3 days

    ✔ should allow admin to reset alerts (39ms)

    ✔ should not allow non-admin to reset alerts


  8 passing (3s)


**Additional Notes**
- Security: Only authorized accounts can interact with critical functions. Unauthorized attempts trigger an error.
- Dependencies: The project uses OpenZeppelin’s AccessControl for secure role management.
- Gas Optimization: The contracts are optimized for gas efficiency by reusing role checks and minimizing state changes.

# License
This project is licensed under the MIT License.
