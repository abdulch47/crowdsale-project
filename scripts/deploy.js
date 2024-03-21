//to deploy the AAT token

async function main() {
const [deployer] = await ethers.getSigners();
  // Get the contract factory
  const tokenFactory = await ethers.getContractFactory("AAT");

  // Deploy the contract
  const myTokenFactory = await tokenFactory.deploy('0xE4AFcDCd300199dd977DC2E97bbe6DD00Fe0e439'); //add a factory address here

  console.log("AAT Token Contract Address:", myTokenFactory.address);
}

//to deploy the  AST Token Factory
// async function main() {
//   const [deployer] = await ethers.getSigners();
//     // Get the contract factory
//     const tokenFactory = await ethers.getContractFactory("ASTTokenFactory"); 
  
//     // Deploy the contract
//     const myTokenFactory = await tokenFactory.deploy("0x12785FC9Ad49ABEA2dA1A019e071B88F37aC9f10", "0x76399c8A5027fD58A1D1b07500ccC8a223BEE0c3"); // add a pool wallet and asset locked wallet here
  
//     console.log("AST Token Factory Contract Address:", myTokenFactory.address);
//   }

//to deploy a movie factory
// async function main() {
//   const [deployer] = await ethers.getSigners();
//     // Get the contract factory
//     const factory = await ethers.getContractFactory("MovieFactory"); 
  
//     // Deploy the contract
//     const myFactory = await factory.deploy("0xF8aFD010F137071c1FFaef51025259E128615d5A", "10000000000000000"); // add a usdt address and fee in usdt with decimals
  
//     console.log("Factory Contract Address:", myFactory.address);
//   }

//to deploy the primary marketplace
// async function main() {
//   const [deployer] = await ethers.getSigners();
//     // Get the contract factory
//     const factory = await ethers.getContractFactory("PrimaryMarketplace"); 
  
//     // Deploy the contract
//     const myFactory = await factory.deploy("0x450546aD5bd2383D93E9676eF26545505f405D3D"); // add a factory address
  
//     console.log("Primary Contract Address:", myFactory.address);
//   }

//to deploy a secondary marketplace
// async function main() {
//   const [deployer] = await ethers.getSigners();
//     // Get the contract factory
//     const factory = await ethers.getContractFactory("SecondaryMarketplace"); 
  
//     // Deploy the contract
//     const myFactory = await factory.deploy("0x450546aD5bd2383D93E9676eF26545505f405D3D"); // add a factory address
  
//     console.log("Secondary Contract Address:", myFactory.address);
//   }

// async function main() {
//   const [deployer] = await ethers.getSigners();
//     // Get the contract factory
//     const factory = await ethers.getContractFactory("ArabianHorses"); 
  
//     // Deploy the contract
//     const myFactory = await factory.deploy(); // add a factory address
  
//     console.log("Secondary Contract Address:", myFactory.address);
//   }

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
