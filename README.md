 
SupplyChainAccessControl deployed to: 0x7c9D4E3769FD085566de1DB20E5703D3Ec50d37f
block explorer: https://www.aiascan.com/address/0x7c9D4E3769FD085566de1DB20E5703D3Ec50d37f

ProductTracking deployed to: 0xe34c86A03F17E29F77beeE7c898Adae4dD578006
block explorer: https://www.aiascan.com/address/0xe34c86A03F17E29F77beeE7c898Adae4dD578006
 
 npx hardhat test


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
    1) should not allow non-admin to reset alerts


  7 passing (3s)
  1 failing

  1) Supply Chain Tracking System
       should not allow non-admin to reset alerts:
     AssertionError: Expected transaction to be reverted with reason 'AccessControl: account 0x70997970c51812dc3a010c7d01b50e0d17dc79c8 is missing role 0x0000000000000000000000000000000000000000000000000000000000000000', but it reverted with reason 'Caller is not an admin'
      at Context.<anonymous> (test\ProductTracking.test.js.js:194:9)