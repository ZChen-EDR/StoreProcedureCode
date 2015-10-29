Delimiter //
DROP PROCEDURE IF EXISTS createReportOutputSetupFromExisting;
CREATE PROCEDURE createReportOutputSetupFromExisting(IN sourceReportOutputSetupID BIGINT,
                                                     IN newReportOutputSetupGuid VARCHAR(32),
                                                     IN ownerCompanyID BIGINT,
                                                     IN ownerCompanyGuid VARCHAR(32),
                                                     IN accountID BIGINT,
                                                     IN accountGuid VARCHAR(32),
                                                     IN name VARCHAR(256))
BEGIN



DECLARE ROS_name_conflict CONDITION FOR SQLSTATE '45000'; 
DECLARE error_message VARCHAR(256);
DECLARE IsValid TINYINT;


SELECT ros.OwnerCompanyID
INTO @formalOwnerCompanyID
FROM PARCEL.ReportOutputSetup ros
WHERE ros.ReportOutputSetupID = sourceReportOutputSetupID;




/*Convert the report output setup name to all CAPS - Standardized Name*/

SET @standardized_name = TRIM(UPPER(name));
SET @newName = name;  
SET @newAccountID = accountID;
SET @ownerCompanyGuidBinary = PARCEL.guidToBinary(ownerCompanyGuid);
SET @newReportOutputGuidBinary = PARCEL.guidToBinary(newReportOutputSetupGuid);
SET @accountGuidBinary = PARCEL.guidToBinary(accountGuid);


/* This is to check, if the report output setup name already exists for the same company */

SELECT PARCEL.checkValidROSName(@standardized_name, @formalOwnerCompanyID) INTO IsValid;

IF IsValid = 1 THEN

/* This is to get the code value ID for the Report Setup Type Code like Transmittal Setup, Table of Content Setup  */

			
			
			/* insert select from the exsiting */
			
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
		  SELECT @newName,
		         @standardized_name,
		         ownerCompanyID,
		         ros.ROSStyleSheetFilePath,
		         ros.ROSDocument,
		         @newAccountID,
		         ros.ReportSetupTypeCode,
		         @newReportOutputGuidBinary,
					@ownerCompanyGuidBinary,
					@accountGuidBinary
		  FROM PARCEL.ReportOutputSetup ros
		  WHERE ros.ReportOutputSetupID = sourceReportOutputSetupID;
												
			
			
			
			/* This is to retrieve all the attributes for the inserted report output setup record  */
			
			CALL PARCEL.getReportOutputSetupDetail(newReportOutputSetupGuid);
			
			ELSE 
			
			/* This is throw an error, if an active report setup output name for an company already exists */
			
				   CALL PARCEL.getErrorMessage('ROS_name_conflict', error_message);
				   SIGNAL ROS_name_conflict 
			      	SET MESSAGE_TEXT = error_message;
			
			END IF;

END //
Delimiter ;
      