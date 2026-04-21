// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CarbonCreditCoins is ERC20, Ownable {

    uint256 public constant MAX_SUPPLY = 20000000000 * 10**18;

    string public imageURI;

    string public projectInfo =
        "Carbon Credit Coins (CCC) is a digital asset designed to represent carbon credit value, supported by certified carbon credits under custody and subject to independent audits.";

    struct Certificate {
        string ipfsHash;
        uint256 timestamp;
        string description;
    }

    Certificate[] public certificates;

    event CertificateAdded(uint256 indexed id, string ipfsHash, string description);
    event ReserveUpdated(uint256 amount);

    uint256 public carbonReserve;

    constructor(
        address masterWallet,
        string memory _imageURI
    )
        ERC20("Carbon Credit Coins", "CCC")
        Ownable(masterWallet)   // 🔥 FIX AQUI
    {
        require(masterWallet != address(0), "Invalid wallet");

        imageURI = _imageURI;

        _mint(masterWallet, MAX_SUPPLY);
    }

    function addCertificate(string memory _ipfsHash, string memory _desc) external onlyOwner {
        certificates.push(Certificate(_ipfsHash, block.timestamp, _desc));
        emit CertificateAdded(certificates.length - 1, _ipfsHash, _desc);
    }

    function updateReserve(uint256 _amount) external onlyOwner {
        carbonReserve = _amount;
        emit ReserveUpdated(_amount);
    }
}
