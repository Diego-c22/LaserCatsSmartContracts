// SPDX-License-Identifier: Mit

pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./ERC721-upgradeable/ERC721AUpgradeable.sol";

/** @author NFT Constructer Team **/
/** @title LaserCats */
contract LaserCats is ERC721AUpgradeable, OwnableUpgradeable {
    event Minted(address from, address to, uint256 quantity, uint256 price);

    /**
     * @dev Initialize upgradeable storage (constructor).
     * @custom:restriction This function only can be executed one time.
     */
    function initialize() public initializerERC721A initializer {
        __ERC721A_init({
            name_: "Laser Cats",
            symbol_: "LC",
            pricePublicSale_: 2 ether,
            pricePreSale_: 0,
            amountForPreSale_: 0,
            amountForPublicSale_: 5000,
            amountForFreeSale_: 0,
            maxBatchSizePublicSale_: 3,
            maxBatchSizePreSale_: 0,
            unlockTime: 1662082345
        });
        __Ownable_init();
    }

    /**
     * @dev Mint NFT taking as reference presale values
     * @param quantity Quantity of nfts to mint in transaction
     * @custom:restriction Quantity must be less or equals to maxBatchSize
     */

    /**
     * @dev Mint NFT taking as reference public sale values
     * @param quantity Quantity of nfts to mint in transaction
     * @custom:restriction Quantity must be less or equals to maxBatchSize
     */
    function mintTo(uint256 quantity) external payable {
        uint256 unlockTime = ERC721AStorage.layout()._unlockTime;
        require(
            unlockTime < block.timestamp && unlockTime > 0,
            "Public sale is not active"
        );
        require(
            ERC721AStorage.layout()._amountForPublicSale >=
                (ERC721AStorage.layout()._publicSaleCurrentIndex + quantity),
            "Transfer exceeds total supply."
        );
        require(
            ERC721AStorage.layout()._tokensBoughtPublicSale[msg.sender] +
                quantity <=
                ERC721AStorage.layout()._maxBatchSizePublicSale,
            "Transfer exceeds max amount."
        );
        require(
            maxSupply() >= (totalSupply() + quantity),
            "ERC721A: Amount of tokens exceeds max supply."
        );
        uint256 amount = quantity * price();
        require(msg.value == amount, "Price not covered.");
        _mint(msg.sender, quantity);

        unchecked {
            ERC721AStorage.layout()._publicSaleCurrentIndex += quantity;
            ERC721AStorage.layout()._tokensBoughtPublicSale[
                msg.sender
            ] += quantity;
        }
        emit Minted(address(0), msg.sender, quantity, amount);
    }

    /**
     * @dev Mint NFT taking as reference public sale values
     * @param quantity Quantity of nfts to mint in transaction
     * @custom:restriction Quantity must be less or equals to maxBatchSize
     */
    function ownerMint(uint256 quantity) external onlyOwner {
        require(
            ERC721AStorage.layout()._amountForFreeSale >=
                (ERC721AStorage.layout()._freeSaleCurrentIndex + quantity),
            "Transfer exceeds total supply."
        );
        _mint(msg.sender, quantity);

        unchecked {
            ERC721AStorage.layout()._freeSaleCurrentIndex += quantity;
        }
    }

    /**
     * @dev set time to unlock mintFunction.
     * @param unlockTime Date where mint will be unlocked in epoch time.
     * @custom:restriction Only owner can execute this function
     */
    function setUnlockTime(uint256 unlockTime) external onlyOwner {
        ERC721AStorage.layout()._unlockTime = unlockTime;
    }

    function getUnlockTime() external view returns (uint256) {
        return ERC721AStorage.layout()._unlockTime;
    }

    /**
     * @dev active or deactivate pre-sale.
     * @param status Use true to activate or false to deactivate.
     * @custom:restriction Only owner can execute this function
     */
    function activePreSale(bool status) external onlyOwner {
        ERC721AStorage.layout()._preSaleActive = status;
    }

    /**
     * @dev Set base URI.
     * @param baseURI_ A string used as base to generate nfts.
     * @custom:restriction Only owner can execute this function
     */
    function setBaseURI(string memory baseURI_) external onlyOwner {
        ERC721AStorage.layout()._baseUri = baseURI_;
    }

    /**
     * @dev Set hidden base URI.
     * @param baseURI_ A string used as url when base url is hidden to generate nfts.
     * @custom:restriction Only owner can execute this function
     */
    function setHiddenBaseURI(string memory baseURI_) external onlyOwner {
        ERC721AStorage.layout()._hiddenBaseUri = baseURI_;
    }

    /**
     * @dev Change quantity of tokens for public sale.
     * @param quantity Quantity of tokens for public sale.
     * @custom:restriction Only owner can execute this function
     */
    function setPublicSaleQuantity(uint256 quantity) external onlyOwner {
        require(quantity >= 0, "Quantity must be greater than 0");
        ERC721AStorage.layout()._amountForPublicSale = quantity;
    }

    /**
     * @dev Change quantity of tokens for pre sale.
     * @param quantity Quantity of tokens for pre sale.
     * @custom:restriction Only owner can execute this function
     */
    function setPreSaleQuantity(uint256 quantity) external onlyOwner {
        require(quantity >= 0, "Quantity must be greater than 0");
        ERC721AStorage.layout()._amountForPreSale = quantity;
    }

    /**
     * @dev Change quantity of tokens for free sale.
     * @param quantity Quantity of tokens for free sale.
     * @custom:restriction Only owner can execute this function
     */
    function setFreeSaleQuantity(uint256 quantity) external onlyOwner {
        require(quantity >= 0, "Quantity must be greater than 0");
        ERC721AStorage.layout()._amountForFreeSale = quantity;
    }

    /**
     * @dev Change price for tokens of public sale.
     * @param unlockPrice Price for tokens of public sale.
     * @custom:restriction Only owner can execute this function
     */
    function setUnlockPrice(uint256 unlockPrice) external onlyOwner {
        require(unlockPrice >= 0, "Price must be greater than 0");
        ERC721AStorage.layout()._pricePublicSale = unlockPrice;
    }

    /**
     * @dev Change price for tokens of pre sale.
     * @param price_ Price for tokens of pre sale.
     * @custom:restriction Only owner can execute this function
     */
    function setPreSalePrice(uint256 price_) external onlyOwner {
        require(price_ >= 0, "Price must be greater than 0");
        ERC721AStorage.layout()._pricePreSale = price_;
    }

    /**
     * @dev Change limit per wallet for tokens of pre sale.
     * @param limit quantity of tokens allowed per wallet in pre sale.
     * @custom:restriction Only owner can execute this function
     */
    function setPreSaleLimit(uint256 limit) external onlyOwner {
        require(limit > 0, "Limit must be greater than 0");
        ERC721AStorage.layout()._maxBatchSizePreSale = limit;
    }

    /**
     * @dev Change limit per wallet for tokens of public sale.
     * @param limit quantity of tokens allowed per wallet in public sale.
     * @custom:restriction Only owner can execute this function
     */
    function setPublicSaleLimit(uint256 limit) external onlyOwner {
        require(limit > 0, "Limit must be greater than 0");
        ERC721AStorage.layout()._maxBatchSizePublicSale = limit;
    }

    /**
     * @dev Get all the balance of the contract (profits).
     * @custom:restriction Only owner can execute this function
     */
    function getProfits() external onlyOwner {
        (bool sent, ) = payable(msg.sender).call{value: address(this).balance}(
            ""
        );
        require(sent, "Failed to send Ether");
    }

    /**
     * @dev Hidde or show baseURI.
     * @param status Use true to show or false to hidde.
     * @custom:restriction Only owner can execute this function
     */
    function revelBaseURI(bool status) external onlyOwner {
        ERC721AStorage.layout()._reveled = status;
    }

    function getTokensOfAddress(address address_)
        external
        view
        returns (string[] memory)
    {
        return _getTokensOfAddress(address_);
    }

    function preSalePrice() external view returns (uint256) {
        return ERC721AStorage.layout()._pricePreSale;
    }

    function publicSalePrice() external view returns (uint256) {
        return ERC721AStorage.layout()._pricePublicSale;
    }

    function amountForPublicSale() external view returns (uint256) {
        return ERC721AStorage.layout()._amountForPublicSale;
    }

    function amountForPreSale() external view returns (uint256) {
        return ERC721AStorage.layout()._amountForPreSale;
    }

    function uriSuffix() external view returns (string memory) {
        return ERC721AStorage.layout()._uriSuffix;
    }

    function setUriSuffix(string memory uriSuffix_)
        external
        onlyOwner
        returns (string memory)
    {
        return ERC721AStorage.layout()._uriSuffix = uriSuffix_;
    }

    function baseURI() external view returns (string memory) {
        return ERC721AStorage.layout()._baseUri;
    }

    // Change function to get max supply
    function maxSupply() public view returns (uint256) {
        return (ERC721AStorage.layout()._amountForPublicSale +
            ERC721AStorage.layout()._amountForFreeSale);
    }

    function price() public view returns (uint256) {
        uint256 unlockTime = ERC721AStorage.layout()._unlockTime;
        uint256 unlockPrice = ERC721AStorage.layout()._pricePublicSale;
        if (unlockTime > block.timestamp) return unlockPrice;
        uint256 timeFromUnlock = block.timestamp - unlockTime;
        // Make a division between 1200 because it is the equivalent to 20 minutes in epoch time
        uint256 timeLapses = timeFromUnlock / 1200;
        uint256 currentPrice = unlockPrice - (0.05 ether * timeLapses);
        if (currentPrice > 0.5 ether) return currentPrice;
        return 0.5 ether;
    }

    function tokensURI() external view returns (string[] memory) {
        return _getTokens();
    }
}
