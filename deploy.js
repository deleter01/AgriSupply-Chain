const hre = require("hardhat");

async function main() {
  // const samsContractFactory = await ethers.getContractFactory(
  //   "samsContract"
  // )
  const resourseContractFactory = await ethers.getContractFactory(
    "ResourseContract"
  )
  // const shipmentContractFactory = await ethers.getContractFactory(
  //   "ShipmentContract"
  // )
  const retailContractFactory = await ethers.getContractFactory(
    "RetailerContract"
  )


  console.log("Deploying contract...")
  // const SamsContract = await samsContractFactory.deploy()
  // await SamsContract.deployed()
  const ResourseContract = await resourseContractFactory.deploy()
  await ResourseContract.deployed()
  // const ShipmentContract = await shipmentContractFactory.deploy()
  // await ShipmentContract.deployed()
  const RetailContract = await retailContractFactory.deploy()
  await RetailContract.deployed()

  // console.log(`Deployed contract 1 to: ${SamsContract.address}`)
  console.log(`Deployed contract 2 to: ${ResourseContract.address}`)
  // console.log(`Deployed contract 3 to: ${ShipmentContract.address}`)
  console.log(`Deployed contract 3 to: ${RetailContract.address}`)

  await ResourseContract.RegisterUser("admin","0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC","admin","admin","admin@gmail.com",1)
  await ResourseContract.RegisterUser("Employee","0x70997970C51812dc3A010C7d01b50e0d17dc79C8","emp","emp","emp@gmail.com",2)
  await ResourseContract.RegisterUser("group 5","0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266","group 5","group 5","retail@gmail.com",5)
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

