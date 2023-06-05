CREATE DATABASE  IF NOT EXISTS `LinkGiggling` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `LinkGiggling`;
-- MySQL dump 10.13  Distrib 8.0.33, for macos13 (arm64)
--
-- Host: 127.0.0.1    Database: LinkGiggling
-- ------------------------------------------------------
-- Server version	8.0.33

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'LinkGiggling'
--
/*!50003 DROP PROCEDURE IF EXISTS `ADD_MEDIA` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADD_MEDIA`(
    IN p_URL TEXT,
    IN p_title VARCHAR(255),
    IN p_category INT,
    IN p_resolution SET('360', '720', '1080', '1440', '2160'),
    IN p_length TIME
)
BEGIN
    DECLARE v_medID INT;
    DECLARE v_success BOOLEAN DEFAULT TRUE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_success = FALSE;
    
    START TRANSACTION;
    
    INSERT INTO media(URL) VALUES(p_URL);
    SET v_medID = LAST_INSERT_ID();
    
    INSERT INTO medInfo(medID, title, category)
    VALUES(v_medID, p_title, p_category);
    
    INSERT INTO quality(medID, resolution, length)
    VALUES(v_medID, p_resolution, p_length);
    
    IF v_success THEN
        SELECT JSON_OBJECT(
            'success', true
        ) AS ADD_MEDIA;
        COMMIT;
    ELSE
        ROLLBACK;
        SELECT JSON_OBJECT('success', false) AS ADD_MEDIA;
    END IF;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ADD_USER` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADD_USER`(
    IN userID VARCHAR(45),
    IN password CHAR(32),
    IN mail VARCHAR(50)
)
BEGIN
    DECLARE hash VARBINARY(64);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT JSON_OBJECT('success', false) AS ADD_USER;
    END;
    SET hash = SHA2(password, 256);
    INSERT INTO user(userID, password, mail)
    VALUES(userID, hash, mail);
    SELECT JSON_OBJECT('success', true) AS ADD_USER;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DEL_HISTORY` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DEL_HISTORY`(
    IN p_userID INT,
    IN p_medID INT
)
BEGIN
    DECLARE v_success BOOLEAN DEFAULT TRUE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_success = FALSE;
    
    DELETE FROM `history`
    WHERE `userID` = p_userID AND `medID` = p_medID;

    IF v_success THEN
        COMMIT;
        SELECT JSON_OBJECT(
            'success', true
        ) AS DEL_HISTORY;
    ELSE
        ROLLBACK;
        SELECT JSON_OBJECT(
            'success', false
        ) AS DEL_HISTORY;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DEL_MEDIA` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DEL_MEDIA`(
    IN p_medID INT
)
BEGIN
    DECLARE v_success BOOLEAN DEFAULT TRUE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_success = FALSE;

    DELETE FROM media WHERE `medID` = p_medID;
    DELETE FROM medID WHERE `medID` = p_medID;
    DELETE FROM quality WHERE `medID` = p_medID;

    IF v_success THEN
        SELECT JSON_OBJECT(
            'success', true
        ) AS DEL_MEDIA;
        COMMIT;
    ELSE
        ROLLBACK;
        SELECT JSON_OBJECT('success', false) AS DEL_MEDIA;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DEL_USER` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DEL_USER`(
    IN p_userCode INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT JSON_OBJECT('success', false) AS DEL_USER;
    END;
    DELETE FROM user WHERE userCode = p_userCode;
    DELETE FROM profile WHERE userCode = p_userCode;
    DELETE FROM history WHERE userCode = p_userCode;
    SELECT JSON_OBJECT('success', true) AS DEL_USER;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GET_HISTORY` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GET_HISTORY`(
    IN p_userID INT
)
BEGIN
    DECLARE v_history JSON;
    
    SELECT JSON_ARRAYAGG(
        JSON_OBJECT(
            'medID', medID,
            'bufferingStart', bufferingStart
        )
    ) INTO v_history
    FROM history
    WHERE `userID` = p_userID;

    SELECT v_history AS GET_HISTORY;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GET_PROFILE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GET_PROFILE`(
   IN p_userCode INT
)
BEGIN
    DECLARE v_nickname VARCHAR(30);
    DECLARE v_userInfo SET('male', 'female');
    DECLARE v_birthYear INT;
    DECLARE v_nation CHAR(2);

    SELECT `nickname`, `userInfo`, `birthYear`, `nation`
    INTO v_nickname, v_userInfo, v_birthYear, v_nation
    FROM profile
    WHERE `userCode` = p_userCode;

    SELECT JSON_OBJECT(
    'nickname', v_nickname,
    'userInfo', v_userInfo,
    'birthYear', v_birthYear,
    'nation', v_nation) AS GET_PROFILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GET_QUALITY` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GET_QUALITY`(
    IN p_medID INT
)
BEGIN
    DECLARE v_quality JSON;
    
    SELECT JSON_ARRAYAGG(
        JSON_OBJECT(
            'resolution', resolution,
            'length', length
        )
    ) INTO v_quality
    FROM quality
    WHERE `medID` = p_medID;

    SELECT v_quality AS GET_QUALITY;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GET_URL` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GET_URL`(
    IN p_medID INT
)
BEGIN
    DECLARE v_URL TEXT;
    SELECT `URL` INTO v_URL FROM media
    WHERE `medID` = p_medID;
    SELECT JSON_OBJECT('URL', v_URL) AS GET_URL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GET_USERID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GET_USERID`(
    IN p_mail VARCHAR(50)
)
BEGIN
    SELECT JSON_OBJECT('userID', userID) AS GET_USERID FROM `user`
    WHERE `mail` = p_mail;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `LOGIN` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `LOGIN`(
    IN p_userID VARCHAR(45),
    IN p_password VARBINARY(64)
)
BEGIN
    DECLARE hash VARBINARY(64);
    DECLARE v_password VARBINARY(64);
    SET hash = SHA2(p_password, 256);
    SELECT `password` INTO v_password FROM `user`
    WHERE `userID` = p_userID;
    IF v_password = hash THEN
        SELECT JSON_OBJECT('userCode', userCode) AS LOGIN FROM `user` WHERE `userID` = p_userID;
    ELSE
        SELECT JSON_OBJECT('userCode', -1) AS LOGIN;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RESET` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `RESET`()
BEGIN
    DELETE FROM `user`;
    DELETE FROM `quality`;
    DELETE FROM `profile`;
    DELETE FROM `medInfo`;
    DELETE FROM `media`;
    DELETE FROM `history`;
    ALTER TABLE `user` AUTO_INCREMENT = 1;
    ALTER TABLE `media` AUTO_INCREMENT = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SEAR_CATEGORY` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SEAR_CATEGORY`(
    IN p_category INT
)
BEGIN
    DECLARE search JSON;
    
    SELECT JSON_ARRAYAGG(
        JSON_OBJECT(
            'medID', medID,
            'title', title,
            'category', category,
            'URL', URL
        )
    ) INTO search
    FROM medInfo
    WHERE category = p_category;

    SELECT search AS SEAR_CATEGORY;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SEAR_TITLE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SEAR_TITLE`(
    IN p_title VARCHAR(255)
)
BEGIN
    DECLARE t_title VARCHAR(255);
    DECLARE v_media JSON;

    SET t_title = TRIM(BOTH FROM p_title);
    SELECT JSON_ARRAYAGG(
        JSON_OBJECT(
            'medID', medID,
            'title', title,
            'category', category,
            'URL', URL
        )
    ) INTO v_media
    FROM medInfo
    WHERE title LIKE CONCAT('%', t_title, '%');

    SELECT v_media AS SEAR_TITLE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SET_MAIL` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SET_MAIL`(
    IN p_userCode INT,
    IN p_mail VARCHAR(50)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT JSON_OBJECT('success', false) AS SET_MAIL;
    END;
    UPDATE `user` SET `mail` = p_mail
    WHERE `userCode` = p_userCode;
    SELECT JSON_OBJECT('success', true) AS SET_MAIL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SET_MEDIA` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SET_MEDIA`(
    IN p_medID INT,
    IN p_URL TEXT,
    IN p_title VARCHAR(255),
    IN p_category INT,
    IN p_resolution SET('360', '720', '1080', '1440', '2160'),
    IN p_length TIME
)
BEGIN
    DECLARE v_success BOOLEAN DEFAULT TRUE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_success = FALSE;

    START TRANSACTION;

    UPDATE `media` SET `URL` = p_URL WHERE `medID` = p_medID;
    UPDATE `medInfo` 
    SET `title` = p_title, `category` = p_category 
    WHERE `medID` = p_medID;
    UPDATE `quality`
    SET `resolution` = p_resolution, `length` = p_length
    WHERE `medID` = p_medID;

    IF v_success THEN
        COMMIT;
        SELECT JSON_OBJECT(
            'success', true
        ) AS SET_MEDIA;
    ELSE
        ROLLBACK;
        SELECT JSON_OBJECT(
            'success', false
        ) AS SET_MEDIA;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SET_PASSWORD` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SET_PASSWORD`(
    IN p_userID VARCHAR(45),
    IN p_password VARBINARY(64)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT JSON_OBJECT('success', false) AS SET_PASSWORD;
    END;
    UPDATE `user` SET `password` = p_password
    WHERE `userID` = p_userID;
    SELECT JSON_OBJECT('success', true) AS SET_PASSWORD;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SET_PROFILE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SET_PROFILE`(
    IN p_userCode INT,
    IN p_nickname VARCHAR(30),
    IN p_userInfo SET('mail', 'female'),
    IN p_birthYear INT,
    IN p_nation CHAR(2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT JSON_OBJECT('success', false) AS SET_PROFILE;
    END;
    DELETE FROM `profile`
    WHERE `userCode` = p_userCode;
    INSERT INTO profile(userCode, nickname, userInfo, birthYear, nation)
    VALUES(p_userCode, p_nickname, p_userInfo, p_birthYear, p_nation);
    SELECT JSON_OBJECT('success', true) AS SET_PROFILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SET_USERID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = euckr */ ;
/*!50003 SET character_set_results = euckr */ ;
/*!50003 SET collation_connection  = euckr_korean_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SET_USERID`(
    IN p_userCode INT,
    IN p_userID VARCHAR(45)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT JSON_OBJECT('success', false) AS SET_USERID;
    END;
    UPDATE `user` SET `userID` = p_userID
    WHERE `userCode` = p_userCode;
    SELECT JSON_OBJECT('success', true) AS SET_USERID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-05 11:52:32
