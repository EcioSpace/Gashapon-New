const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("GashaponOpen", function () {


  let nftCoreContract;
  let gashaponOpener;
  let ecioTokenContract;
  let randomRateSTF;
  let randomRateLTD;

  //Accounts
  let owner;
  let addr1;
  let addr2;
  let addr3;
  let addr4;
  let addr5;
  let addrs;

  before(async function () {
    [owner, addr1, addr2,addr3,addr4,addr5, ...addrs] = await ethers.getSigners();

    const ECIONFTCore = await ethers.getContractFactory("ECIONFTCore");
    nftCoreContract = await ECIONFTCore.deploy();
    nftCoreContract.deployed();

    await nftCoreContract.connect(owner).initialize();

    const GashaponOpener = await ethers.getContractFactory("GashaponOpener");
    gashaponOpener = await GashaponOpener.deploy();

    const EcioTest = await ethers.getContractFactory("EcioTest");
    ecioTokenContract = await EcioTest.deploy();
    
  });


  it("Should mint ERC20 Token", async function (){

    await ecioTokenContract.connect(owner).mint(addr1.address, 100000);

    expect(await ecioTokenContract.balanceOf(addr1.address)).to.equal(100000);

  });

  it("GashaOpener should have role MINTER", async function () {

    await nftCoreContract.connect(owner).addOperatorAddress(gashaponOpener.address);
    
    await nftCoreContract.connect(owner).addOperatorAddress(gashaponOpener.address);

    expect(nftCoreContract.connect(owner).operators(gashaponOpener.address)).to.equal(true);

  });
   

});
