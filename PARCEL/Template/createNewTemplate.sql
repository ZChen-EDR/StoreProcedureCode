Delimiter //
CREATE  PROCEDURE `createNewTemplate`(IN `name` VARCHAR(256), 
                                      IN `ownerCompanyID` BIGINT, 
                                      IN `ownerCompanyGuid` VARCHAR,
												  IN `shortName` VARCHAR(256), 
												  IN `description` VARCHAR(256), 
												  IN `isMobile` TINYINT, 
												  IN `accountID` BIGINT, 
												  IN `accountGuid` VARCHAR(32),
												  IN `reportTypeID` INT, 
												  IN `templateDocument` LONGTEXT,
												  IN `templateGuid` VARCHAR(32))
	COMMENT 'Create a new template for a particular company'
BEGIN

DECLARE template_name_conflict CONDITION FOR SQLSTATE '45000'; 
DECLARE error_message VARCHAR(256);
DECLARE standardizedName VARCHAR(256);
DECLARE IsValid TINYINT(4);

SET standardizedName = TRIM(UPPER(name));

/* This is to check, if the template name already exists for the same company */




SELECT PARCEL.checkTemplateNameExist(ownerCompanyID, standardizedName) INTO IsValid;

IF IsValid = 1 THEN

/* Insert the new Template details */
SET @ownerCompanyGuid = PARCEL.guidToBinary(ownerCompanyGuid);
SET @accountGuid = PARCEL.guidToBinary(accountGuid);createNewTemplate
SET @
INSERT INTO PARCEL.Template (

				Name,
				StandardizedTemplateName,
				OwnerCompanyID,
				ShortName,
				Description,
				IsMobile,
				CreatedAccountID,
				ReportTypeID,
				TemplateDocument
				                )
				
VALUES      (

				name,
				standardizedName,
				ownerCompanyID,
				shortName,
				description,
				isMobile,
				accountID,
				reportTypeID,
				templateDocument
				                );
				
SELECT LAST_INSERT_ID() INTO templateID;

/* Throws an error if the same template name is entered for an active Company */

ELSE 
	   CALL PARCEL.getErrorMessage('template_name_conflict', error_message);
	   SIGNAL template_name_conflict 
      	SET MESSAGE_TEXT = error_message;

END IF;

CALL PARCEL.getTemplateDetail(templateID);

END