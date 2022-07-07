// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract ConvertToNFT is ERC721URIStorage {
// Magic given to us by OpenZeppelin to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

  event NewEpicNFTMinted(address sender, uint256 tokenId);

    // We need to pass the name of our NFTs token and its symbol.
    constructor() ERC721 ("SquareNFT", "SQUARE"){
        console.log("This is my first NFT Contract. Whoa!");
    }


    // A function our user will hit to get their NFT.
    function makeAnEpicNFT(string calldata imageURI, string calldata title, string calldata description) public {
      // Get the current tokenId, this starts at 0.
      uint256 newItemId = _tokenIds.current();

// Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    title,
                    '", "description": "',
                    description,
                    '", "image": "',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    imageURI,
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

      // Actually mint the NFT to the sender using msg.sender.
    _safeMint(msg.sender, newItemId);

     // Set the NFTs data.
    _setTokenURI(newItemId, finalTokenUri);
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

     // Increment the counter for when the next NFT is minted.
    _tokenIds.increment();

    // Emitting NFT Address
    emit NewEpicNFTMinted(msg.sender, newItemId);
    }
    
}


