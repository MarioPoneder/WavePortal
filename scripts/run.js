const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy();
  await waveContract.deployed();

  console.log("Contract deployed to:", waveContract.address);
  console.log("Contract deployed by:", owner.address);

  waveContract.on("Waved", (from, timestamp, nickname, message, tip) => {
    console.log("Event: ", from, " has waved and tipped ", tip, "!");
  });

  let waveCount;
  waveCount = await waveContract.getTotalWaves();

  let waveTxn = await waveContract.wave("Owner", "It's-a me, Mario!");
  await waveTxn.wait();
  waveCount = await waveContract.getTotalWaves();

  waveTxn = await waveContract.connect(randomPerson).wave("Random generous person", "Here's your tip!", { value: 100000 });
  waveRes = await waveTxn.wait();
  //console.log(waveRes.events[0].args);
  waveCount = await waveContract.getTotalWaves();

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);
  
  let ownerWaves = await waveContract.connect(randomPerson).getWavesOf(owner.address);
  console.log(ownerWaves);
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
