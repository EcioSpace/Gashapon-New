// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract RandomRateLTD is Ownable {
    using Strings for string;
    uint16 private constant NFT_TYPE = 0; //Kingdom
    uint16 private constant KINGDOM = 1; //Kingdom
    uint16 private constant TRANING_CAMP = 2; //Training Camp
    uint16 private constant GEAR = 3; //Battle Gear
    uint16 private constant DRO = 4; //Battle DRO
    uint16 private constant SUITE = 5; //Battle Suit
    uint16 private constant BOT = 6; //Battle Bot
    uint16 private constant GEN = 7; //Human GEN
    uint16 private constant WEAP = 8; //WEAP
    uint16 private constant COMBAT_RANKS = 9; //Combat Ranks
    uint16 private constant BLUEPRINT_COMM = 0;
    uint16 private constant BLUEPRINT_RARE = 1;
    uint16 private constant BLUEPRINT_EPIC = 2;
    uint16 private constant GENOMIC_COMMON = 3;
    uint16 private constant GENOMIC_RARE = 4;
    uint16 private constant GENOMIC_EPIC = 5;
    uint16 private constant SPACE_WARRIOR = 6;
    uint16 private constant COMMON_BOX = 0;
    uint16 private constant RARE_BOX = 1;
    uint16 private constant EPIC_BOX = 2;
    uint16 private constant SPECIAL_BOX = 3;
    uint16 private constant COMMON = 0;
    uint16 private constant RARE = 1;
    uint16 private constant EPIC = 2;

    //EPool
    mapping(uint16 => uint16) public EPool;

    mapping(uint16 => uint16[]) SWPoolResults;
    mapping(uint16 => uint16[]) SWPoolValues;
    mapping(uint16 => uint256[]) SWPoolPercentage;

    function initial() public onlyOwner {
        
        EPool[0] = GEAR; //Battle Gear
        EPool[1] = DRO; //Battle DRO
        EPool[2] = SUITE; //Battle Suit
        EPool[3] = BOT; //Battle Bot
        EPool[4] = WEAP; //WEAP

        //-----------------START COMMON BOX RATE --------------------------------
    
        //SW
        SWPoolResults[TRANING_CAMP] = [0, 1, 2, 3, 4];
        SWPoolPercentage[TRANING_CAMP] = [
            uint256(2000),
            uint256(2000),
            uint256(2000),
            uint256(2000),
            uint256(2000)
        ];

        for (
            uint16 p = 0;
            p < SWPoolPercentage[TRANING_CAMP].length;
            p++
        ) {
            uint256 qtyItem = (100 *
                SWPoolPercentage[TRANING_CAMP][p]) / 10000;
            for (uint16 i = 0; i < qtyItem; i++) {
                SWPoolValues[TRANING_CAMP].push(
                    SWPoolResults[TRANING_CAMP][p]
                );
            }
        }

        SWPoolResults[SUITE] = [0, 1, 2];
        SWPoolPercentage[SUITE] = [
            uint256(3333),
            uint256(3333),
            uint256(3333)
        ];

        for (
            uint16 p = 0;
            p < SWPoolPercentage[SUITE].length;
            p++
        ) {
            uint256 qtyItem = (100 * SWPoolPercentage[SUITE][p]) /
                10000;
            for (uint16 i = 0; i < qtyItem; i++) {
                SWPoolValues[SUITE].push(
                    SWPoolResults[SUITE][p]
                );
            }
        }
        
        // 786 common / 583 rare / 125 epic / 500 Limited
        SWPoolResults[GEN] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 21];
        SWPoolPercentage[GEN] = [
            uint256(786),
            uint256(786),
            uint256(786),
            uint256(786),
            uint256(786),
            uint256(786),
            uint256(786),
            uint256(583),
            uint256(583),
            uint256(583),
            uint256(583),
            uint256(583),
            uint256(583),
            uint256(125),
            uint256(125),
            uint256(125),
            uint256(125),
            uint256(500)
        ];

        for (uint16 p = 0; p < SWPoolPercentage[GEN].length; p++) {
            uint256 qtyItem = (100 * SWPoolPercentage[GEN][p]) /
                10000;
            for (uint16 i = 0; i < qtyItem; i++) {
                SWPoolValues[GEN].push(
                    SWPoolResults[GEN][p]
                );
            }
        }

        
        SWPoolResults[WEAP] = [0, 1, 2, 3];
        SWPoolPercentage[WEAP] = [
            uint256(2500),
            uint256(2500),
            uint256(2500),
            uint256(2500)
        ];
        for (uint16 p = 0; p < SWPoolPercentage[WEAP].length; p++) {
            uint256 qtyItem = (100 * SWPoolPercentage[WEAP][p]) /
                10000;
            for (uint16 i = 0; i < qtyItem; i++) {
                SWPoolValues[WEAP].push(
                    SWPoolResults[WEAP][p]
                );
            }
        }

        //-----------------END COMMON BOX RATE --------------------------------
    }

    function getEquipmentPool(uint16 _number) public view returns (uint16) {
        return EPool[_number];
    }

    function getSpaceWarriorPool(
        uint16 _part,
        uint16 _number
    ) public view returns (uint16) {
        uint16 _modNumber = uint16(_number) %
            uint16(SWPoolValues[_part].length);
        return SWPoolValues[_part][_modNumber];
    }
}