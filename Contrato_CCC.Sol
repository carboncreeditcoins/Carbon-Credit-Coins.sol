// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
Carbon Credit Coins (CCC) - Institutional Advanced Version

✔ ERC20 + Governance (Votes)
✔ Fixed Supply (20 Billion)
✔ Certificate Registry (IPFS)
✔ Carbon Reserve Tracking
✔ Master Wallet Mint
✔ Professional Metadata

IMPORTANT:
This contract does NOT guarantee price or returns.
Market defines value.
*/

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CarbonCreditCoins is ERC20Votes, Ownable {

    // =============================
    // 📊 SUPPLY
    // =============================
    uint256 public constant MAX_SUPPLY = 20000000000 * 10**18;

    // =============================
    // 🖼️ METADATA
    // =============================
    string public imageURI;

    string public projectInfo =
        "Carbon Credit Coins (CCC) is a digital asset designed to represent carbon credit value, supported by certified carbon credits under custody and subject to independent audits and verification.";

    // =============================
    // 📜 CERTIFICATES
    // =============================
    struct Certificate {
        string ipfsHash;
        uint256 timestamp;
        string description;
    }

    Certificate[] public certificates;

    event CertificateAdded(uint256 indexed id, string ipfsHash, string description);

    function addCertificate(string memory _ipfsHash, string memory _desc) external onlyOwner {
        certificates.push(Certificate(_ipfsHash, block.timestamp, _desc));
        emit CertificateAdded(certificates.length - 1, _ipfsHash, _desc);
    }

    function getCertificatesCount() external view returns (uint256) {
        return certificates.length;
    }

    // =============================
    // 🌱 CARBON RESERVE
    // =============================
    uint256 public carbonReserve;

    event ReserveUpdated(uint256 amount);

    function updateReserve(uint256 _amount) external onlyOwner {
        carbonReserve = _amount;
        emit ReserveUpdated(_amount);
    }

    // =============================
    // 🚀 CONSTRUCTOR
    // =============================
    constructor(
        address masterWallet,
        string memory _imageURI
    )
        ERC20("Carbon Credit Coins", "CCC")
        ERC20Permit("Carbon Credit Coins")
    {
        require(masterWallet != address(0), "Invalid wallet");

        imageURI = _imageURI;

        _mint(masterWallet, MAX_SUPPLY);
    }

    // =============================
    // 🔄 REQUIRED OVERRIDES
    // =============================
    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20Votes)
    {
        super._burn(account, amount);
    }
}
