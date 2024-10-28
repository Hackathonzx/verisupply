const hre = require("hardhat");

async function main() {
    // Deploy SupplyChainAccessControl contract
    const SupplyChainAccessControl = await hre.ethers.getContractFactory("SupplyChainAccessControl");
    const accessControl = await SupplyChainAccessControl.deploy();
    await accessControl.waitForDeployment();
    console.log(`SupplyChainAccessControl deployed to: ${accessControl.target}`);

    // Deploy ProductTracking contract with the address of SupplyChainAccessControl
    const ProductTracking = await hre.ethers.getContractFactory("ProductTracking");
    const productTracking = await ProductTracking.deploy();
    await productTracking.waitForDeployment();
    console.log(`ProductTracking deployed to: ${productTracking.target}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
