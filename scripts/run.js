const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy();
  await waveContract.deployed();

  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  waveContract.on("Waved", (sender, tip) => {
    console.log("Event: ", sender, " has waved and tipped ", tip, "!");
  });

  let waveCount;
  waveCount = await waveContract.getTotalWaves();

  let waveTxn = await waveContract.wave();
  await waveTxn.wait();
  waveCount = await waveContract.getTotalWaves();

  waveTxn = await waveContract.connect(randomPerson).wave({ value: 1000 });
  waveRes = await waveTxn.wait();
  waveCount = await waveContract.getTotalWaves();

  waveCount = await waveContract.connect(randomPerson).getMyWaves();
  
  waveCount = await waveContract.connect(randomPerson).getWavesOf(owner.address);

  //console.log(waveRes.events[0].args);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0); // remove this line to leave the runtime enough time to process contract events
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
