// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Universities is ERC721, Pausable, Ownable {
    constructor() ERC721("Universities", "UNI")  {}
    string baseExtension=".json";
    string _baseURIx="https://gateway.pinata.cloud/ipfs/QmQLBRkMXKVSFBtae7JMo6nXYYtoYBaH2u8NrQ2tNVuiy1/";
    bool [] randomIDs=new bool[](20);
    uint256 nonce=0;
    function createRandomTokenId() internal returns (uint256){
        uint256 tokenId= uint256(keccak256(abi.encodePacked(block.timestamp,block.difficulty,msg.sender,nonce)))%20;
        while(randomIDs[tokenId]){
            nonce++;
            tokenId= uint256(keccak256(abi.encodePacked(block.timestamp,block.difficulty,msg.sender,nonce)))%20;    
        }
        return tokenId;
    } 

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId),baseExtension)) : "";
    }
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIx;
    }
    function buyNFT() public payable returns (string memory) {
        require(msg.value==1 wei);
        uint256 tokenId=createRandomTokenId();
        randomIDs[tokenId]=true;
        _safeMint(msg.sender, tokenId);
        string memory a=tokenURI(tokenId);
        return a;
     }

    
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}

