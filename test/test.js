const { expect } = require("chai");
const { ethers } = require("hardhat");
const { time } = require("@nomicfoundation/hardhat-network-helpers");

describe("Supply Chain Tracking System", function () {
    let owner, manufacturer, transporter, retailer, otherAccount;
    let productTracking;

    beforeEach(async function () {
        [owner, manufacturer, transporter, retailer, otherAccount] = await ethers.getSigners();

        // Deploy ProductTracking contract directly (it includes access control)
        const ProductTrackingFactory = await ethers.getContractFactory("ProductTracking");
        productTracking = await ProductTrackingFactory.deploy();
        await productTracking.waitForDeployment();
        console.log("ProductTracking deployed at:", await productTracking.getAddress());

        // Grant roles directly on ProductTracking contract
        await productTracking.grantManufacturerRole(manufacturer.address);
        await productTracking.grantTransporterRole(transporter.address);
        await productTracking.grantRetailerRole(retailer.address);
    });

    it("should allow a manufacturer to register a product", async function () {
        await productTracking.connect(manufacturer).registerProduct(
            1,
            "Product 1",
            ethers.encodeBytes32String("QR_HASH_1")
        );
        const product = await productTracking.getProductDetails(1);
        expect(product.name).to.equal("Product 1");
        expect(product.origin).to.equal(manufacturer.address);
    });

    it("should allow authorized parties to update product status", async function () {
        await productTracking.connect(manufacturer).registerProduct(
            2,
            "Product 2",
            ethers.encodeBytes32String("QR_HASH_2")
        );
        await productTracking.connect(transporter).updateStatus(
            2,
            "In Transit",
            25, // temperature
            12345, // latitude
            67890 // longitude
        );
        const product = await productTracking.getProductDetails(2);
        expect(product.status).to.equal("In Transit");
    });

    it("should restrict unauthorized parties from updating product status", async function () {
        await productTracking.connect(manufacturer).registerProduct(
            3,
            "Product 3",
            ethers.encodeBytes32String("QR_HASH_3")
        );
        await expect(
            productTracking.connect(otherAccount).updateStatus(
                3,
                "In Transit",
                30,
                12345,
                67890
            )
        ).to.be.revertedWith("Not authorized to update status.");
    });

    it("should log product history correctly on status updates", async function () {
        await productTracking.connect(manufacturer).registerProduct(
            4,
            "Product 4",
            ethers.encodeBytes32String("QR_HASH_4")
        );
        await productTracking.connect(transporter).updateStatus(
            4,
            "Shipped",
            22,
            1000,
            2000
        );
        await productTracking.connect(retailer).updateStatus(
            4,
            "Received",
            20,
            1500,
            2500
        );

        const history = await productTracking.getProductHistory(4);
        expect(history.length).to.equal(2);
        expect(history[0].status).to.equal("Shipped");
        expect(history[1].status).to.equal("Received");
    });

    it("should allow verifying a product's QR code", async function () {
        const qrHash = ethers.encodeBytes32String("QR_HASH_5");
        await productTracking.connect(manufacturer).registerProduct(5, "Product 5", qrHash);
        const isVerified = await productTracking.verifyProductQR(5, qrHash);
        expect(isVerified).to.be.true;
    });

    it("should trigger an alert if the product is inactive for over 3 days", async function () {
        await productTracking.connect(manufacturer).registerProduct(
            6,
            "Product 6",
            ethers.encodeBytes32String("QR_HASH_6")
        );
        await productTracking.connect(transporter).updateStatus(
            6,
            "In Transit",
            25,
            1000,
            2000
        );

        // Fast-forward time by 3 days + 1 second
        await time.increase(3 * 24 * 60 * 60 + 1);

        await productTracking.connect(retailer).updateStatus(
            6,
            "Delivered",
            20,
            1500,
            2500
        );

        expect(await productTracking.alerts(6)).to.be.true;
    });

    it("should allow admin to reset alerts", async function () {
        await productTracking.connect(manufacturer).registerProduct(
            7,
            "Product 7",
            ethers.encodeBytes32String("QR_HASH_7")
        );
        
        // Set up alert condition
        await productTracking.connect(transporter).updateStatus(
            7,
            "In Transit",
            25,
            1000,
            2000
        );
        
        await time.increase(3 * 24 * 60 * 60 + 1);
        
        await productTracking.connect(retailer).updateStatus(
            7,
            "Delivered",
            20,
            1500,
            2500
        );
        
        // Verify alert is set
        expect(await productTracking.alerts(7)).to.be.true;
        
        // Reset alert
        await productTracking.connect(owner).resetAlert(7);
        
        // Verify alert is reset
        expect(await productTracking.alerts(7)).to.be.false;
    });

    it("should not allow non-admin to reset alerts", async function () {
        await productTracking.connect(manufacturer).registerProduct(
            8,
            "Product 8",
            ethers.encodeBytes32String("QR_HASH_8")
        );
        
        // Set up alert condition
        await productTracking.connect(transporter).updateStatus(
            8,
            "In Transit",
            25,
            1000,
            2000
        );
        
        await time.increase(3 * 24 * 60 * 60 + 1);
        
        await productTracking.connect(retailer).updateStatus(
            8,
            "Delivered",
            20,
            1500,
            2500
        );
        
        // Try to reset alert with non-admin account
        await expect(
            productTracking.connect(manufacturer).resetAlert(8)
        ).to.be.revertedWith("AccessControl: account " + manufacturer.address.toLowerCase() + " is missing role " + ethers.ZeroHash);
    });
}); 