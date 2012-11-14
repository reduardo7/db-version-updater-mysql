-- Execute Queries for update.
--
-- Eduardo Cuomo | eduardo.cuomo.ar@gmail.com
--



-- Select DB
USE databaseName;



-- Create table
CREATE TABLE IF NOT EXISTS `database_version` (
  `version` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `executed_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`version`)
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
  
  SET @cQuery = CONCAT('INSERT INTO mem_version_control SELECT version FROM database_version WHERE version = ', @iVersion);
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
-- NOTE: A unique query per call. There is not designed for multi-query per call.


CALL database_version_control(
  1,
  'First test',
  'INSERT INTO category (version, name) VALUES (1, "First")'
);

CALL database_version_control(
  2,
  'Sec. Test',
  'DELETE FROM category WHERE id = 123'
);

-- X QUERY START (NOTE: One query per call)
CALL database_version_control(
  3,
  'X Query (1)',
  'ALTER TABLE `category` ADD `test` INT NOT NULL'
);

CALL database_version_control(
  4,
  'X Query (2)',
  'INSERT INTO category (`test`) VALUES (123)'
);
-- X QUERY END
