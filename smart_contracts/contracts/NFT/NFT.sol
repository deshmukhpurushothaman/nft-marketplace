// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";

contract NFT is ERC721, ERC721URIStorage, ERC721Enumerable {
    address payable owner;
    //The fee charged by the marketplace to be allowed to list an NFT
    uint256 listPrice = 0.01 ether;

    constructor() ERC721("My First Token", "MFT") {
        owner = payable(msg.sender);
    }

    using Address for address;
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    Counters.Counter public _tokenIds;

    mapping(string => bool) public nftUri;
    // mapping(uint256 => address) public owner;

    struct ListedToken {
        uint256 tokenId;
        uint256 price;
        address payable seller;
        bool isListed;
    }
    mapping(uint256 => ListedToken) private idToListedToken;

    //the event emitted when a token is successfully listed
    event TokenListedSuccess(
        uint256 indexed tokenId,
        uint256 price,
        address seller,
        bool isListed
    );

    /**
     * Mint + Issue NFT
     *
     * @param to - NFT will be issued to recipient
     * @param uri - Artwork Metadata IPFS hash
     */
    function safeMint(address to, string memory uri) public returns (uint256) {
        require(nftUri[uri] == false, "NFT for hash already minted");
        nftUri[uri] = true;
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _safeMint(to, newTokenId);
        _setTokenURI(newTokenId, uri);
        owner[newTokenId] = to;
        createToken(to, newTokenId, price);
        return newTokenId;
    }

    function createToken(
        address to,
        uint256 tokenId,
        uint256 price
    ) private {
        require(price > 0, "Price should be greater than zero");
        idToListedToken[tokenId] = ListedToken(
            tokenId,
            price,
            payable(to),
            true
        );
        // _transfer(to, address(this), tokenId);
        //Emit the event for successful transfer. The frontend parses this message and updates the end user
        emit TokenListedSuccess(tokenId, price, to, true);
    }

    /**
     * Get Holder Token IDs
     *
     * @param owner - Owner of the Tokens
     */
    // function getOwnerTokens(address owner)
    //     public
    //     view
    //     returns (uint256[] memory)
    // {
    //     uint256 count = balanceOf(owner);
    //     uint256[] memory result = new uint256[](count);
    //     for (uint256 index = 0; index < count; index++) {
    //         result[index] = tokenOfOwnerByIndex(owner, index);
    //     }
    //     return result;
    // }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    );

    //This will return all the NFTs currently listed to be sold on the marketplace
    function getAllNFTs() public view returns (ListedToken[] memory) {
        uint256 nftCount = _tokenIds.current();
        ListedToken[] memory tokens = new ListedToken[](nftCount);
        uint256 currentIndex = 0;
        uint256 currentId;
        //at the moment currentlyListed is true for all, if it becomes false in the future we will
        //filter out currentlyListed == false over here
        for (uint256 i = 0; i < nftCount; i++) {
            currentId = i + 1;
            ListedToken storage currentItem = idToListedToken[currentId];
            tokens[currentIndex] = currentItem;
            currentIndex += 1;
        }
        //the array 'tokens' has the list of all NFTs in the marketplace
        return tokens;
    }

    function executeSale(uint256 tokenId) public payable {
        uint256 price = idToListedToken[tokenId].price;
        address seller = idToListedToken[tokenId].seller;
        require(
            msg.value == price,
            "Please submit the asking price in order to complete the purchase"
        );

        //update the details of the token
        idToListedToken[tokenId].isListed = true;
        idToListedToken[tokenId].seller = payable(msg.sender);
        _itemsSold.increment();

        //Actually transfer the token to the new owner
        _transfer(seller, msg.sender, tokenId);
        //approve the marketplace to sell NFTs on your behalf
        approve(seller, tokenId);

        //Transfer the listing fee to the marketplace creator
        payable(owner).transfer(listPrice);
        //Transfer the proceeds from the sale to the seller of the NFT
        payable(seller).transfer(msg.value);
    }

    //
    //  OVERRIDES
    //
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }
}
