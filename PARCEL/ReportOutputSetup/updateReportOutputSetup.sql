Delimiter //
DROP PROCEDURE IF EXISTS updateReportOutputSetup;
CREATE  PROCEDURE `updateReportOutputSetup`(IN `reportOutputSetupGuid` VARCHAR(32), 
                                            IN `name` VARCHAR(256),
														  IN `cssPath` VARCHAR(256), 
														  IN `jsonData` VARCHAR(256), 
														  IN `accountID` BIGINT,
														  IN `accountGuid` VARCHAR(32))
	
	COMMENT 'Update the report output setup details'
BEGIN

DECLARE ROS_name_conflict CONDITION FOR SQLSTATE '45000'; 
DECLARE error_message VARCHAR(256);
DECLARE standardized_name VARCHAR(256);
DECLARE IsValid INT;

SET standardized_name = TRIM(UPPER(name));
SET @reportOutputSetupGuidBinary = PARCEL.guidToBinary(reportOutputSetupGuid);
SET @accountGuidBinary = PARCEL.guidToBinary(accountGuid);
SET @newName = name;

UPDATE  PARCEL.ReportOutputSetup ros
SET ros.StandardizedROSName = null
WHERE ros.ReportOutputSetupGuidBinary = @reportOutputSetupGuidBinary;

SELECT ros.OwnerCompanyID, ros.ReportOutputSetupID
INTO @currentOwnerCompanyID, @reportOutputSetupID
FROM PARCEL.ReportOutputSetup ros
WHERE ros.ReportOutputSetupGuidBinary = @reportOutputSetupGuidBinary;

/* This is to check, if the report output setup name already exists for the same company */

SELECT PARCEL.checkValidROSName(standardized_name, @currentOwnerCompanyID)
INTO IsValid;

IF IsValid THEN

UPDATE PARCEL.ReportOutputSetup ros

		 SET ros.Name = @newName,
		     ros.StandardizedROSName = standardized_name,
		     ros.ROSStyleSheetFilePath = cssPath,
		     ros.ROSDocument = jsonData,
		     ros.ModifiedAccountID = accountID,
		     ros.ModifiedTimestamp = CURRENT_TIME()
		 WHERE ros.ReportOutputSetupID = @reportOutputSetupID;

/* This is to retrieve all the attributes for the inserted report output setup record  */

CALL PARCEL.getReportOutputSetupDetail(reportOutputSetupGuid);

ELSE 

/* This is throw an error, if an active report setup output name for an company already exists */

		   CALL PARCEL.getErrorMessage('ROS_name_conflict', error_message);
         SIGNAL ROS_name_conflict 
               SET MESSAGE_TEXT = error_message;

END IF;

END //
Delimiter ;