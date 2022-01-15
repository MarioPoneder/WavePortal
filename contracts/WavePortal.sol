// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";


contract WavePortal is Ownable {
    using Address for address payable;

    event Waved(address indexed from, uint256 timestamp, string nickname, string message, uint256 indexed tip);

    struct Wave {
        address from; // The address of the user who waved.
        uint256 timestamp; // The timestamp when the user waved.
        string nickname; // The nickname of the user.
        string message; // The message the user sent.
        uint256 tip;  // The amout of wei the user tipped.
    }

    Wave[] waves;
    mapping (address => uint256[]) addressToWaveIndices;
    mapping (bytes32 => address) nicknameHashToAddress;

    constructor() {
        console.log("WavePortal constructor");
    }

    modifier nicknameCheck(string calldata _nickname) {
        require(bytes(_nickname).length <= 50, "Nickname is too long");
        bytes32 nicknameHash = keccak256(abi.encodePacked(_nickname));
        address nicknameOwner = nicknameHashToAddress[nicknameHash];
        require(nicknameOwner == address(0) || nicknameOwner == msg.sender, "Nickname is already taken");
        nicknameHashToAddress[nicknameHash] = msg.sender;
        _;
    }

    function wave(string calldata _nickname, string calldata _message) external payable nicknameCheck(_nickname)  {
        addressToWaveIndices[msg.sender].push(waves.length);
        waves.push(Wave(msg.sender, block.timestamp, _nickname, _message, msg.value));
        
        console.log("%s has waved and tipped %d!", msg.sender, msg.value);
        emit Waved(msg.sender, block.timestamp, _nickname, _message, msg.value);
    }

    function getAllWaves() external view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() external view returns (uint256) {
        console.log("We have %d total waves!", waves.length);
        return waves.length;
    }

    function getMyWaves() external view returns (Wave[] memory) {
        return getWavesOf(msg.sender);
    }

    function getWavesOf(address _address) public view returns (Wave[] memory) {
        uint256[] storage waveIndices = addressToWaveIndices[msg.sender];
        uint256 waveCount = waveIndices.length;
        require(waveCount > 0, "Address did not wave yet");
        
        Wave[] memory wavesOf = new Wave[](waveCount);
        for (uint256 i = 0; i < waveCount; i++) {
            wavesOf[i] = waves[waveIndices[i]];
        }

        console.log("%s has waved %d time(s)!", _address, waveCount);
        return wavesOf;
    }

    function collectTips() external onlyOwner {
        payable(owner()).sendValue(address(this).balance);
    }
}
