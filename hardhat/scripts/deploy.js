import { ethers } from "hardhat";

async function main() {

  const Competition = await ethers.getContractFactory("EditStarsCompetition");
  const competition = await Competition.deploy("0xb3971BCef2D791bc4027BbfedFb47319A4AAaaAa");

  await competition.deployed();

  console.log(`Competition deployed to ${competition.address}`);

  const QF = await ethers.getContractFactory("EditStarsSeamlessQF");
  const qf = await QF.deploy();

  await qf.deployed();

  console.log(`QF deployed to ${qf.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
