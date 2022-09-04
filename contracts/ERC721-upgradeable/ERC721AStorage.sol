// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library ERC721AStorage {
    // Reference type for token approval.
    struct TokenApprovalRef {
        address value;
    }

    struct Layout {
        // =============================================================
        //                            STORAGE
        // =============================================================

        // The next token ID to be minted.
        uint256 _currentIndex;
        // The number of tokens burned.
        uint256 _burnCounter;
        // Token name
        string _name;
        // Token symbol
        string _symbol;
        // Mapping from token ID to ownership details
        // An empty struct value does not necessarily mean the token is unowned.
        // See {_packedOwnershipOf} implementation for details.
        //
        // Bits Layout:
        // - [0..159]   `addr`
        // - [160..223] `startTimestamp`
        // - [224]      `burned`
        // - [225]      `nextInitialized`
        // - [232..255] `extraData`
        mapping(uint256 => uint256) _packedOwnerships;
        // Mapping owner address to address data.
        //
        // Bits Layout:
        // - [0..63]    `balance`
        // - [64..127]  `numberMinted`
        // - [128..191] `numberBurned`
        // - [192..255] `aux`
        mapping(address => uint256) _packedAddressData;
        // Mapping from token ID to approved address.
        mapping(uint256 => ERC721AStorage.TokenApprovalRef) _tokenApprovals;
        // Mapping from owner to operator approvals
        mapping(address => mapping(address => bool)) _operatorApprovals;
        // Maximum number of mints allowed by transaction or wallet in presale
        uint256 _maxBatchSizePreSale;
        // Maximum number of mints allowed by transaction or wallet in publicSale
        uint256 _maxBatchSizePublicSale;
        // Maximum number of nfts that can be minted
        uint256 _collectionSize;
        // Maximum number of ntfs that can be minted in presale.
        uint256 _amountForPreSale;
        // Maximum number of ntfs that can be minted in public sale.
        uint256 _amountForPublicSale;
        // Maximum number of ntfs that can be minted in free.
        uint256 _amountForFreeSale;
        // Price by nft in public sale.
        uint256 _pricePublicSale;
        // Price by nft in presale.
        uint256 _pricePreSale;
        // Items sold in presale
        uint256 _preSaleCurrentIndex;
        // Items sold in  public sale
        uint256 _publicSaleCurrentIndex;
        uint256 _freeSaleCurrentIndex;
        // Determine if public sale is active
        bool _publicSaleActive;
        // Determine if pre-sale is active
        bool _preSaleActive;
        // false if base uri is hidden
        bool _reveled;
        // Save base URI
        string _baseUri;
        // Save hidden base URI
        string _hiddenBaseUri;
        // Save suffix base uri
        string _uriSuffix;
        // Save unix time to unlock minting
        uint256 _unlockTime;
        mapping(address => uint) _tokensBoughtPreSale;
        mapping(address => uint) _tokensBoughtPublicSale;
    }

    bytes32 internal constant STORAGE_SLOT =
        keccak256("ERC721A.contracts.storage.ERC721A");

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
