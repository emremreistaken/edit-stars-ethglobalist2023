require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("hardhat-celo");

const { PRIVATE_KEY, INFURA_API_KEY, LINEASCAN_API_KEY } = process.env;

module.exports = {
  solidity: "0.8.20",
  networks: {
    linea_testnet: {
      url: `https://linea-goerli.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [PRIVATE_KEY],
    },
    linea_mainnet: {
      url: `https://linea-mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [PRIVATE_KEY],
    },
    alfajores: {
      url: "https://alfajores-forno.celo-testnet.org",
      accounts: [PRIVATE_KEY],
      chainId: 44787
    },
    mumbai: {
      url: "https://polygon-mumbai.infura.io/v3/f96f8158ceb74bb4b29b213586541fad",
      accounts: [PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      alfajores: "ZUZ9FUMEHBAMB7RCKDFGDQJYXT8BD3KMHG",
  },
    customChains: [
      {
        network: "linea_testnet",
        chainId: 59140,
        urls: {
          apiURL: "https://api-testnet.lineascan.build/api",
          browserURL: "https://goerli.lineascan.build/address"
        }
      },
      {
        network: "alfajores",
        chainId: 44787,
        urls: {
          apiURL: "https://apı-alfajores.celoscan.io/apı",
          browserURL: "https://alfajores.celoscan.io/address"
        }
      },
    ]
  }
};