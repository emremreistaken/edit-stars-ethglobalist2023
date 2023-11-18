import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';

require('dotenv').config();

const config: HardhatUserConfig = {
  solidity: {
    version: '0.8.20',
  },
  networks: {
    // for mainnet
    'base-mainnet': {
      url: 'https://mainnet.base.org',
      accounts: [process.env.PRIVATE_KEY as string],
      gasPrice: 1000000000,
    },
    // for testnet
    'mantleTest': {
      url: 'https://rpc.testnet.mantle.xyz',
      accounts: [process.env.PRIVATE_KEY as string],
      gasPrice: 1000000000,
    },
    // for local dev environment
    'base-local': {
      url: 'http://localhost:8545',
      accounts: [process.env.PRIVATE_KEY as string],
      gasPrice: 1000000000,
    },
    'mumbai': {
      url: 'https://polygon-mumbai.infura.io/v3/f96f8158ceb74bb4b29b213586541fad',
      accounts: [process.env.PRIVATE_KEY as string],
      gasPrice: 1000000000,
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
    customChains: [
      {
        network: "mantleTest",
        chainId: Number(process.env.MANTLE_TESTNET_CHAIN_ID),
        urls: {
          apiURL: `${process.env.MANTLE_TESTNET_EXPLORER}api`,
          browserURL: process.env.MANTLE_TESTNET_EXPLORER!,
        },
      },
    ],
  },
  defaultNetwork: 'hardhat',
};

export default config;