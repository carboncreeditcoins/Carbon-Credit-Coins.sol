// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract CarbonCreditCoins is ERC20, Ownable2Step, Pausable {

    // =========================
    // 🔒 SUPPLY MÁXIMO GLOBAL
    // =========================
    uint256 public immutable MAX_SUPPLY = 20000000000 * 10**18;

    // =========================
    // 🌍 PROOF OF RESERVE (LASTRO REAL)
    // =========================
    uint256 public totalReserveUSD;

    // =========================
    // 🖼️ IDENTIDADE DO PROJETO
    // =========================
    string public imageURI;
    string public projectInfo;

    // =========================
    // 📜 CERTIFICADOS CARBONO (IPFS)
    // =========================
    struct Certificate {
        string ipfsHash;
        uint256 timestamp;
        string description;
    }

    Certificate[] public certificates;

    // =========================
    // 📡 EVENTS (AUDITORIA ON-CHAIN)
    // =========================
    event ReserveUpdated(uint256 newReserveUSD);
    event CertificateAdded(uint256 indexed id, string ipfsHash);
    event MintExecuted(address indexed to, uint256 amount);
    event BurnExecuted(address indexed from, uint256 amount);
    event EmergencyPause(bool status);

    // =========================
    // 🚀 CONSTRUCTOR
    // =========================
    constructor(
        address masterWallet,
        string memory _imageURI,
        string memory _projectInfo
    )
        ERC20("Carbon Credit Coins", "CCC")
        Ownable(masterWallet)
    {
        require(masterWallet != address(0), "Invalid wallet");

        imageURI = _imageURI;
        projectInfo = _projectInfo;

        _mint(masterWallet, MAX_SUPPLY);
    }

    // =========================
    // 🌍 ATUALIZAÇÃO DE LASTRO
    // =========================
    function updateReserve(uint256 _usdAmount) external onlyOwner {
        totalReserveUSD = _usdAmount;
        emit ReserveUpdated(_usdAmount);
    }

    // =========================
    // 💰 MINT CONTROLADO POR LASTRO
    // =========================
    function mint(address to, uint256 amount) external onlyOwner {
        require(totalReserveUSD > 0, "No reserve");
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");

        _mint(to, amount);
        emit MintExecuted(to, amount);
    }

    // =========================
    // 🔥 BURN (DESTRUIÇÃO DE TOKENS)
    // =========================
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
        emit BurnExecuted(msg.sender, amount);
    }

    // =========================
    // 📜 CERTIFICADOS CARBONO
    // =========================
    function addCertificate(
        string memory _ipfsHash,
        string memory _desc
    ) external onlyOwner {
        certificates.push(Certificate({
            ipfsHash: _ipfsHash,
            timestamp: block.timestamp,
            description: _desc
        }));

        emit CertificateAdded(certificates.length - 1, _ipfsHash);
    }

    // =========================
    // ⛔ EMERGENCY CONTROL
    // =========================
    function pause() external onlyOwner {
        _pause();
        emit EmergencyPause(true);
    }

    function unpause() external onlyOwner {
        _unpause();
        emit EmergencyPause(false);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }

    // =========================
    // 📊 VIEW FUNCTIONS
    // =========================
    function getReserve() external view returns (uint256) {
        return totalReserveUSD;
    }

    function getCertificatesCount() external view returns (uint256) {
        return certificates.length;
    }
}
