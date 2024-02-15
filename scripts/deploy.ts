import { ethers } from "hardhat";

async function main() {
  const myToken = await ethers.deployContract("CreateERC20Token", [
    "Banwo",
    "Ban",
    18,
    100000,
  ]);

  await myToken.waitForDeployment();
  console.log(`ERC20Token deployed to ${myToken.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
