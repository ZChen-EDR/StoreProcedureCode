Delimiter //
DROP PROCEDURE IF EXISTS createReportOutputSetup;
CREATE  PROCEDURE `createReportOutputSetup`(IN `name` VARCHAR(256), 
                                            IN `ownerCompanyID` BIGINT, 
                                            IN `ownerCompanyGuid` VARCHAR(32),
														  IN `cssPath` VARCHAR(256), 
														  IN `jsonData` VARCHAR(256), 
														  IN `accountID` BIGINT, 
														  IN `accountGuid` VARCHAR(32),
														  IN `setupTypeValue` VARCHAR(256), 
														  IN `reportOutputGuid` VARCHAR(32))
	COMMENT 'Create report output setup details'
BEGIN


DECLARE codeValueID BIGINT;
DECLARE reportOutputSetupID BIGINT;
DECLARE ROS_name_conflict CONDITION FOR SQLSTATE '45000'; 
DECLARE error_message VARCHAR(256);
DECLARE standardized_name VARCHAR(256);
DECLARE IsValid TINYINT;

/*Convert the report output setup name to all CAPS - Standardized Name*/

SET standardized_name = TRIM(UPPER(name));  
SET @ownerCompanyGuidBinary = PARCEL.guidToBinary(ownerCompanyGuid);
SET @reportOutputGuidBinary = PARCEL.guidToBinary(reportOutputGuid);
SET @accountGuidBinary = PARCEL.guidToBinary(accountGuid);

/* This is to check, if the report output setup name already exists for the same company */

SELECT PARCEL.checkValidROSName(standardized_name, ownerCompanyID) INTO IsValid;

IF IsValid = 1 THEN

/* This is to get the code value ID for the Report Setup Type Code like Transmittal Setup, Table of Content Setup  */

			SELECT lcv.LocalCodeValueID 
			FROM PARCEL.LocalCodeValue lcv
			JOIN PARCEL.LocalCodeTable lct ON lcv.LocalCodeTableID = lct.LocalCodeTableID
			WHERE lct.CodeTableName = 'ReportSetupType' AND lcv.CodeValueShortName = setupTypeValue
			INTO codeValueID;
			
			/* Insert all the respective attributes for report output setup in the table */
			
			INSERT INTO 
			PARCEL.ReportOutputSetup ( 
												Name,
												StandardizedROSName, 
												OwnerCompanyID, 
												ROSStyleSheetFilePath, 
												ROSDocument, 
												CreatedAccountID, 
												ReportSetupTypeCode,
												ReportOutputSetupGuidBinary,
												OwnerCompanyGuidBinary,
												CreatedAccountGuidBinary)
					VALUES             ( 
												name,
												standardized_name, 
												ownerCompanyID, 
												cssPath, 
												jsonData, 
												accountID, 
												codeValueID,
												@reportOutputGuidBinary,
												@ownerCompanyGuidBinary,
												@accountGuidBinary);
			
			
			
			/* This is to retrieve all the attributes for the inserted report output setup record  */
			
			CALL PARCEL.getReportOutputSetupDetail(reportOutputGuid);
			
			ELSE 
			
			/* This is throw an error, if an active report setup output name for an company already exists */
			
				   CALL PARCEL.getErrorMessage('ROS_name_conflict', error_message);
				   SIGNAL ROS_name_conflict 
			      	SET MESSAGE_TEXT = error_message;
			
			END IF;

END //
Delimiter ;