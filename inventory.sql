-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.32-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for tgb_aim
CREATE DATABASE IF NOT EXISTS `tgb_aim` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `tgb_aim`;

-- Dumping structure for table tgb_aim.inventory
CREATE TABLE IF NOT EXISTS `inventory` (
  `identifier` varchar(50) DEFAULT NULL,
  `inventory` longtext DEFAULT NULL,
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table tgb_aim.inventory: ~1 rows (approximately)
INSERT INTO `inventory` (`identifier`, `inventory`) VALUES
	('steam:11000013ee882db', '{"slot36":"","slot28":"","slot2":"WEAPON_COMBATPISTOL","holster10":"WEAPON_ASSAULTSHOTGUN","slot31":"","slot33":"","slot10":"","slot22":"","slot4":"","slot11":"","slot27":"","slot3":"WEAPON_COMBATPDW","holster5":"WEAPON_PISTOL","holster9":"WEAPON_ASSAULTRIFLE","slot14":"","slot25":"","slot24":"","slot15":"","slot29":"","slot20":"","holster2":"OXY","slot34":"","slot1":"","slot6":"","slot23":"","holster1":"WEAPON_ASSAULTSHOTGUN","slot9":"","slot8":"","slot19":"","holster7":"ARMOUR","slot30":"","holster3":"ARMOUR","slot17":"","slot26":"","holster8":"ARMOUR","slot5":"WEAPON_CARBINERIFLE","slot7":"","holster6":"ARMOUR","slot18":"","slot16":"","slot32":"","slot12":"","slot13":"","slot21":"","holster4":"WEAPON_AUTOSHOTGUN","slot35":""}');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
