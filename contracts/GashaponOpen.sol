// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


interface ERC721_CONTRACT {
    function safeMint(address to, string memory partCode) external;
}

interface RANDOM_CONTRACT {
    function startRandom() external returns (uint256);
}

interface RANDOM_RATE {
    function getGenPool(
        uint16 _rarity,
        uint16 _number
    ) external view returns (uint16);

    function getNFTPool(uint16 _number)
        external
        view
        returns (uint16);

    function getEquipmentPool(uint16 _number) external view returns (uint16);

    function getBlueprintPool(
        uint16 _rarity,
        uint16 eTypeId,
        uint16 _number
    ) external view returns (uint16);

    function getSpaceWarriorPool(
        uint16 _part,
        uint16 _number
    ) external view returns (uint16);
}

contract GashaponOpener is Ownable {
    using Strings for string;
    uint8 private constant NFT_TYPE = 0; //Kingdom

    uint8 private constant SUITE = 5; //Battle Suit
    uint8 private constant WEAP = 8; //WEAP
    uint8 private constant SPACE_WARRIOR = 6;
    uint8 private constant GEN = 7; //Human GEN

    uint8 private constant COMMON = 0;
    uint8 private constant RARE = 1;
    uint8 private constant EPIC = 2;
    uint8 private constant SPACIAL = 3;

    mapping(uint256 => address) ranNumToSender;
    mapping(uint256 => uint256) requestToNFTId;

    event OpenBox(address _by, string partCode);
    event ChangeRandomRateContract(address _address);
    event ChangeMysteryBoxContract(address _address);
    event ChangeNftCoreContract(address _address);
    event ChangeRandomWorkerContract(address _address);
    event ChangeEcioTokenContract(address _address);
    event ChangeLtdStartTime(uint256 time);
    event ChangeLtdEndTime(uint256 time);

    address public mysteryBoxContract;
    address public nftCoreContract;
    address public randomWorkerContract;
    address public ecioTokenContract;

    uint256 public stdGashaPrice = 12500 * 10**18;
    uint256 public promoGashaPrice = 9500 * 10**18;

    uint256 public ltdStartTime = 1642770000;
    uint256 public ltdEndTime = 1642957200;

    enum randomRateType{
        STD,
        LTD
    }

    mapping(randomRateType => address) public randomRateAddress;
    
    

    constructor() {}

    function changeEcioTokenContract(address _address) public onlyOwner {
        ecioTokenContract = _address;
        emit ChangeEcioTokenContract(_address);
    }

    function changeRandomWorkerContract(address _address) public onlyOwner {
        randomWorkerContract = _address;
        emit ChangeRandomWorkerContract(_address);
    }

    function changeMysteryBoxContract(address _address) public onlyOwner {
        mysteryBoxContract = _address;
        emit ChangeMysteryBoxContract(_address);
    }

    function changeNftCoreContract(address _address) public onlyOwner {
        nftCoreContract = _address;
        emit ChangeNftCoreContract(_address);
    }

    //Change RandomRate type Contract

    function changeRandomRateSTD(address _address) public onlyOwner {
        randomRateAddress[randomRateType.STD] = _address;
        emit ChangeRandomRateContract(_address);
    }

    
    function changeRandomRateLTD(address _address) public onlyOwner {
        randomRateAddress[randomRateType.LTD] = _address;
        emit ChangeRandomRateContract(_address);
    }

    function changeLtdStartTime(uint256 newtime) public onlyOwner {
        ltdStartTime = newtime;
        emit ChangeLtdStartTime(newtime);
    }

    function changeLtdEndTime(uint256 newtime) public onlyOwner {
        ltdEndTime = newtime;
        emit ChangeLtdEndTime(newtime);
    }

    function generateNFT(
        randomRateType _RandomType
    ) internal {
        uint256 _randomNumber = RANDOM_CONTRACT(randomWorkerContract)
          .startRandom();

        string memory _partCode = createNFTCode(_randomNumber, _RandomType);
        mintNFT(msg.sender, _partCode);
        emit OpenBox(msg.sender, _partCode);
    }

    function openGasha(randomRateType _RandomType) public {

        if ( _RandomType == randomRateType.STD ) {
            uint256 _balance = IERC20(ecioTokenContract).balanceOf(msg.sender);
            require(_balance >= stdGashaPrice, "ECIO: Your balance is insufficient.");

            //charge ECIO // Need Approval
            IERC20(ecioTokenContract).transferFrom(msg.sender, address(this), stdGashaPrice);

            // mint NFT and random for user.
            generateNFT(_RandomType);

        } else if ( _RandomType == randomRateType.LTD ) {
            uint256 _balance = IERC20(ecioTokenContract).balanceOf(msg.sender);
            require(_balance >= promoGashaPrice, "ECIO: Your balance is insufficient.");
            require(block.timestamp >= ltdStartTime && block.timestamp <= ltdEndTime , "Limited Time: this gasha is not opened ATM");

            //charge ECIO // Need Approval
            IERC20(ecioTokenContract).transferFrom(msg.sender, address(this), promoGashaPrice);

            // mint NFT and random for user.
            generateNFT(_RandomType);
        }
        
    }

    function mintNFT(address to, string memory concatedCode) private {
        ERC721_CONTRACT _nftCore = ERC721_CONTRACT(nftCoreContract);
        _nftCore.safeMint(to, concatedCode);
    }

    function createNFTCode(uint256 _randomNumber, randomRateType _RandomType)
        internal
        view
        returns (string memory)
    {
        string memory partCode;

        //create SW
        partCode = createSW(_randomNumber, _RandomType);

        return partCode;
    }

    function getNumberAndMod(
        uint256 _ranNum,
        uint16 digit,
        uint16 mod
    ) public view virtual returns (uint16) {
        if (digit == 1) {
            return uint16((_ranNum % 10000) % mod);
        } else if (digit == 2) {
            return uint16(((_ranNum % 100000000) / 10000) % mod);
        } else if (digit == 3) {
            return uint16(((_ranNum % 1000000000000) / 100000000) % mod);
        } else if (digit == 4) {
            return uint16(((_ranNum % 10000000000000000) / 1000000000000) % mod);
        } else if (digit == 5) {
            return uint16(((_ranNum % 100000000000000000000) / 10000000000000000) % mod);
        } else if (digit == 6) {
            return uint16(((_ranNum % 1000000000000000000000000) / 100000000000000000000) % mod);
        } else if (digit == 7) {
            return uint16(((_ranNum % 10000000000000000000000000000) / 1000000000000000000000000) % mod);
        } else if (digit == 8) {
            return uint16(((_ranNum % 100000000000000000000000000000000) / 10000000000000000000000000000) % mod);
        }

        return 0;
    }


    function createSW(uint256 _randomNumber, randomRateType _RandomType)
        private
        view
        returns (string memory)
        {
        

        
        // adjust digit to random partcode
        uint16 battleSuiteId = getNumberAndMod(_randomNumber, 5, 1000);
        uint16 humanGenomeId = getNumberAndMod(_randomNumber, 7, 1000);
        uint16 weaponId = getNumberAndMod(_randomNumber, 8, 1000);

        string memory concatedCode = convertCodeToStr(6);

        concatedCode = concateCode(concatedCode, 0); //kingdomCode
        concatedCode = concateCode(concatedCode, 0);
        concatedCode = concateCode(concatedCode, 0);
        concatedCode = concateCode(concatedCode, 0);
        concatedCode = concateCode(
            concatedCode,
            RANDOM_RATE(randomRateAddress[_RandomType]).getSpaceWarriorPool(SUITE, battleSuiteId)
        );
        concatedCode = concateCode(concatedCode, 0);
        concatedCode = concateCode(
            concatedCode,
            RANDOM_RATE(randomRateAddress[_RandomType]).getSpaceWarriorPool(GEN, humanGenomeId)
        );
        concatedCode = concateCode(
            concatedCode,
            RANDOM_RATE(randomRateAddress[_RandomType]).getSpaceWarriorPool(WEAP, weaponId)
        );
        concatedCode = concateCode(concatedCode, 0); //Star
        concatedCode = concateCode(concatedCode, 0); //equipmentCode
        concatedCode = concateCode(concatedCode, 0); //Reserved
        concatedCode = concateCode(concatedCode, 0); //Reserved
        return concatedCode;
    }


    function concateCode(string memory concatedCode, uint256 digit)
        internal
        pure
        returns (string memory)
    {
        concatedCode = string(
            abi.encodePacked(convertCodeToStr(digit), concatedCode)
        );

        return concatedCode;
    }

    function convertCodeToStr(uint256 code)
        private
        pure
        returns (string memory)
    {
        if (code <= 9) {
            return string(abi.encodePacked("0", Strings.toString(code)));
        }

        return Strings.toString(code);
    }
}
