// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const competition = await hre.ethers.deployContract("EditStarsCompetition", ["0xb3971BCef2D791bc4027BbfedFb47319A4AAaaAa"]);

  await competition.waitForDeployment();

  console.log(
    `Competition deployed to ${competition.target}`
  );

  const qf = await hre.ethers.deployContract("EditStarsSeamlessQF");

  await qf.waitForDeployment();

  console.log(
    `QF deployed to ${qf.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
