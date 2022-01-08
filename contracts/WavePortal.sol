// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    event Waved(address sender, uint256 indexed tip);

    uint256 totalWaveCount;
    mapping (address => uint256) addressToWaveCount;

    constructor() {
        console.log("WavePortal constructor");
    }

    function wave() external payable  {
        totalWaveCount++;
        addressToWaveCount[msg.sender]++;
        console.log("%s has waved and tipped %d!", msg.sender, msg.value);
        emit Waved(msg.sender, msg.value);
    }

    function getTotalWaves() external view returns (uint256) {
        console.log("We have %d total waves!", totalWaveCount);
        return totalWaveCount;
    }

    function getMyWaves() external view returns (uint256) {
        uint256 myWaveCount = addressToWaveCount[msg.sender];
        console.log("%s (sender) has waved %d time(s)!", msg.sender, myWaveCount);
        return myWaveCount;
    }

    function getWavesOf(address _address) external view returns (uint256) {
        uint256 waveCount = addressToWaveCount[_address];
        console.log("%s has waved %d time(s)!", _address, waveCount);
        return waveCount;
    }
}
