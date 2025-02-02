// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.28;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../src/DauphineToken.sol";

/// @title Coinflip 10 in a Row
/// @author Tianchan Dong, modified by Jean-Baptiste Astruc
/// @notice Contract used as part of the course Solidity and Smart Contract development

contract Coinflip is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    error SeedTooShort();

    string public seed;
    IERC20 public dauphineToken;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner, address tokenAddress) initializer public {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
        // Storing the token contract address
        dauphineToken = IERC20(tokenAddress);
        // Setting the seed to "It is a good practice to rotate seeds often in gambling"
        seed = "It is a good practice to rotate seeds often in gambling";
    }

    function upgradeTo(address newImplementation) external onlyOwner {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallUUPS(newImplementation, bytes(""), false);
    }
    

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}

    /// @notice Checks user input against contract generated guesses
    /// @param Guesses is a fixed array of 10 elements which holds the user's guesses. The guesses are either 1 or 0 for heads or tails
    /// @return true if user correctly guesses each flip correctly or false otherwise
    function userInput(uint8[10] calldata Guesses, address winner) external returns(bool){
        // Getting the contract generated flips by calling the helper function getFlips()
        uint8[10] memory generatedFlips = getFlips();

        // Comparing each element of the user's guesses with the generated flips and returning true ONLY if all guesses match
        for (uint i = 0; i < 10; i++) {
            if (Guesses[i] != generatedFlips[i]) {
                return false;
            }
        }
        rewardUser(winner);
        return true;
    }

    /// @notice Mints and rewards the winner with 5 DAU
    /// @param winner which is basically the winner
    function rewardUser(address winner) internal {
        DauphineToken(address(dauphineToken)).mint(winner, 5 * 10 ** 18);
    }


    /// @notice Allows the owner of the contract to change the seed to a new one
    /// @param NewSeed is a string which represents the new seed
    function seedRotation(string memory NewSeed) public onlyOwner {
        // Casting the string into a bytes array so we may perform operations on it
        bytes memory seedBytes = bytes(NewSeed);

        // Getting the length of the array
        uint seedLength = seedBytes.length;

        // Checking if the seed is less than 10 characters
        if (seedLength < 10){
            revert SeedTooShort();
        }

        // Setting the seed variable as the NewSeed
        seed = NewSeed;
    }

// -------------------- helper functions -------------------- //
    /// @notice This function generates 10 random flips by hashing characters of the seed
    /// @return a fixed 10 element array of type uint8 with only 1 or 0 as its elements
    function getFlips() public view returns (uint8[10] memory) {
        return [1,1,1,1,1,1,1,1,1,1];
    }
}