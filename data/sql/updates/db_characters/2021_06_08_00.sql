-- DB update 2021_05_30_00 -> 2021_06_08_00
DROP PROCEDURE IF EXISTS `updateDb`;
DELIMITER //
CREATE PROCEDURE updateDb ()
proc:BEGIN DECLARE OK VARCHAR(100) DEFAULT 'FALSE';
SELECT COUNT(*) INTO @COLEXISTS
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'version_db_characters' AND COLUMN_NAME = '2021_05_30_00';
IF @COLEXISTS = 0 THEN LEAVE proc; END IF;
START TRANSACTION;
ALTER TABLE version_db_characters CHANGE COLUMN 2021_05_30_00 2021_06_08_00 bit;
SELECT sql_rev INTO OK FROM version_db_characters WHERE sql_rev = '1622403654219554600'; IF OK <> 'FALSE' THEN LEAVE proc; END IF;
--
-- START UPDATING QUERIES
--

INSERT INTO `version_db_characters` (`sql_rev`) VALUES ('1622403654219554600');

ALTER TABLE `item_loot_storage`
ADD COLUMN `follow_loot_rules` TINYINT UNSIGNED NOT NULL AFTER `randomSuffix`,
ADD COLUMN `freeforall` TINYINT UNSIGNED NOT NULL AFTER `follow_loot_rules`,
ADD COLUMN `is_blocked` TINYINT UNSIGNED NOT NULL AFTER `freeforall`,
ADD COLUMN `is_counted` TINYINT UNSIGNED NOT NULL AFTER `is_blocked`,
ADD COLUMN `is_underthreshold` TINYINT UNSIGNED NOT NULL AFTER `is_counted`,
ADD COLUMN `needs_quest` TINYINT UNSIGNED NOT NULL AFTER `is_underthreshold`; 

--
-- END UPDATING QUERIES
--
UPDATE version_db_characters SET date = '2021_06_08_00' WHERE sql_rev = '1622403654219554600';
COMMIT;
END //
DELIMITER ;
CALL updateDb();
DROP PROCEDURE IF EXISTS `updateDb`;
