import { ethers } from 'hardhat';

async function main() {
  const competition = await ethers.deployContract('EditStarsCompetition', ["0xb3971BCef2D791bc4027BbfedFb47319A4AAaaAa"],  {
    gasLimit: "0x1000000",
  });

  await competition.waitForDeployment();

  console.log('Competition Contract Deployed at ' + competition.target);

  const qf = await ethers.deployContract('EditStarsSeamlessQF', {
    gasLimit: "0x1000000",
  });

  await qf.waitForDeployment();

  console.log('QF Contract Deployed at ' + qf.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});