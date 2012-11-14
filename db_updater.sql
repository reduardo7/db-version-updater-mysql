-- NOTE: A unique query per call. There is not designed for multi-query per call.



-- Select DB
USE databaseName;



-- Create table
CREATE TABLE IF NOT EXISTS `database_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `executed_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `version` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;



-- Procedure
DELIMITER ;;


DROP PROCEDURE IF EXISTS database_version_control ;;


CREATE PROCEDURE database_version_control(IN version INTEGER, IN description VARCHAR(255), IN query TEXT)
BEGIN
  
  DECLARE vc INT;
  
  SET @iVersion=version;
  SET @iDescription=description;
  SET @iQuery=query;
  
  CREATE TEMPORARY TABLE IF NOT EXISTS mem_version_control (v INTEGER) ENGINE=MEMORY;
  DELETE FROM mem_version_control;
  
  SET @cQuery = CONCAT('INSERT INTO mem_version_control SELECT id FROM database_version WHERE version = ', @iVersion);
  PREPARE QUERY FROM @cQuery;
  EXECUTE QUERY;
  DEALLOCATE PREPARE QUERY;
  
  SELECT COUNT(1) INTO vc FROM mem_version_control;
  IF vc = 0 THEN
    PREPARE QUERY FROM @iQuery;
    EXECUTE QUERY;
    DEALLOCATE PREPARE QUERY;
    
    SET @uQuery = CONCAT('INSERT INTO database_version (version, description) VALUE (', @iVersion, ', ''', @iDescription, ''')');
    PREPARE QUERY FROM @uQuery;
    EXECUTE QUERY;
    DEALLOCATE PREPARE QUERY;
  END IF;
  
END ;;


DELIMITER ;



-- Update DB


CALL database_version_control(
  1,
  'PRIMERA PRUEBA',
  'INSERT INTO category (version, name) VALUES (1, "Prueba 1")'
);


CALL database_version_control(
  2,
  'SEGUNDA PRUEBA',
  'INSERT INTO category (version, name) VALUES (2, "Prueba 2")'
);


CALL database_version_control(
  5,
  'asdasdasdas',
  'INSERT INTO category (version, name) VALUES (5, "asdasdasdasdasd")'
);


CALL database_version_control(
  6,
  '666666',
  'INSERT INTO category (version, name) VALUES (6, "666666")'
);
