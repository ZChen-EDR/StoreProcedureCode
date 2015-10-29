Delimiter //
DROP PROCEDURE IF EXISTS updateExistingTemplateDetail;
CREATE  PROCEDURE `updateExistingTemplateDetail`(IN `templateGuid` VARCHAR(32), 
																 IN `name` VARCHAR(256), 
																 IN `shortName` VARCHAR(256), 
																 IN `description` VARCHAR(256), 
																 IN `accountID` BIGINT, 
																 IN `accountGuid` VARCHAR(32),
																 IN `reportTypeValue` VARCHAR(256), 
																 IN `isMobile` TINYINT, 
																 IN `dashboard` VARCHAR(256))
	
	COMMENT 'Update the details for an existing Template'
BEGIN

DECLARE template_name_conflict CONDITION FOR SQLSTATE '45000'; 
DECLARE error_message VARCHAR(256);
DECLARE standardizedName VARCHAR(256);
DECLARE IsValid TINYINT(4);
DECLARE codeValueID BIGINT;
DECLARE reportTypeID BIGINT;

		SET standardizedName = TRIM(UPPER(name));
      SET @templateGuidBinary = PARCEL.guidToBinary(templateGuid);
		SET @accountGuidBinary = PARCEL.guidToBinary(accountGuid);
		
		/*change the name to null so that same name could be passed in*/
		UPDATE PARCEL.Template t
		SET t.StandardizedTemplateName = null
		WHERE t.TemplateID = templateID;
		
		SELECT t.OwnerCompanyID
		INTO @ownerCompanyID
		FROM PARCEL.Template t
		WHERE t.TemplateGuidBinary = @templateGuidBinary;
		
		SELECT PARCEL.checkTemplateNameExist(@ownerCompanyID, standardizedName) INTO IsValid;

		IF IsValid = 1 THEN 
		      
		      
				/* Retrieve the codeValueID for the DashboardOption */
		
				SELECT lcv.LocalCodeValueID 
				FROM   PARCEL.LocalCodeValue lcv
				JOIN   PARCEL.LocalCodeTable lct ON lcv.LocalCodeTableID = lct.LocalCodeTableID
				WHERE  lct.CodeTableName = 'DashboardOptionType' AND lcv.CodeValueShortName = dashboard
				INTO   codeValueID;
				
				/* Retrieve the reportTypeID for the Report Type */
				
				SELECT rt.ReportTypeID
				FROM   PARCEL.ReportType rt
				WHERE  rt.Value = reportTypeValue
				INTO   reportTypeID;
				
				/* Update the template detail which is already existing */
	         
				UPDATE PARCEL.Template t
				SET t.Name = name,
						    t.StandardizedTemplateName = standardizedName,
						    t.ShortName = shortName,
						    t.Description = description,
						    t.ReportTypeID = reportTypeID,
						    t.IsMobile = isMobile,
						    t.DashboardOptionTypeCode = codeValueID,
						    t.TemplateVersion = t.TemplateVersion + 1,
						    t.ModifiedAccountID = accountID,
						    t.ModifiedAccountGuidBinary = @accountGuidBinary,
						    t.ModifiedTimestamp = CURRENT_TIMESTAMP()
				WHERE t.TemplateGuidBinary = @templateGuidBinary;
				
				
		
		ELSE 
				   /* Throws an error if the same template name is entered for an active Company */
					CALL PARCEL.getErrorMessage('template_name_conflict', error_message);
		         SIGNAL template_name_conflict 
		               SET MESSAGE_TEXT = error_message;
		
		END IF;

END //
Delimiter ;