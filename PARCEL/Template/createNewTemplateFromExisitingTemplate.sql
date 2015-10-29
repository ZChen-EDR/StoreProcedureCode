Delimiter //
DROP PROCEDURE IF EXISTS createNewTemplateFromExistingTemplate;
CREATE  PROCEDURE `createNewTemplateFromExistingTemplate`(IN `templateID` BIGINT, 
                                                          IN `ownerCompanyID` BIGINT, 
																			 IN `name` VARCHAR(256), 
																			 IN `accountID` BIGINT,
																			 IN `ownerCompanyGuid` VARCHAR(32),
																			 IN `accountGuid` VARCHAR(32),
																			 IN `templateGuid` VARCHAR(32))
	
	COMMENT 'Create a new template using an existing template'
BEGIN

DECLARE newDescription VARCHAR(256);
DECLARE newShortName VARCHAR(256);
DECLARE newTemplateDocument LONGTEXT;
DECLARE newReportTypeID BIGINT;
DECLARE newIsMobile TINYINT;
DECLARE newTemplateVersion INT;
DECLARE newTemplateStructure LONGTEXT;
DECLARE newSectionNumber VARCHAR(32);
DECLARE newSectionID BIGINT;
DECLARE template_name_conflict CONDITION FOR SQLSTATE '45000'; 
DECLARE error_message VARCHAR(256);
DECLARE standardizedName VARCHAR(256);
DECLARE IsValid TINYINT(4);

/*Exception handler*/

DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	  BEGIN
		   GET DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		   SELECT @p1,@p2;
		   
		   ROLLBACK;
	  
	  END;

START TRANSACTION;
		SET standardizedName = TRIM(UPPER(name));
		
		/* This is to check, if the template name already exists for the same company */
		
		SELECT PARCEL.checkTemplateNameExist(ownerCompanyID, standardizedName) INTO IsValid;
		
		IF IsValid = 1 THEN
			/* Select the parameters for an existing template */
			
			SELECT t.ShortName,
			       t.Description, 
					 t.TemplateDocument,
					 t.ReportTypeID,
					 t.IsMobile,
					 t.TemplateVersion			 
			INTO   newShortName,
					 newDescription,
					 newTemplateDocument,
					 newReportTypeID,
					 newIsMobile,
					 newTemplateVersion
			 FROM PARCEL.Template t 
			 WHERE t.TemplateID = templateID;
					  
			/* Insert the existing attributes and the user input changed attributes */
			SET @ownerCompanyGuidBinary = PARCEL.guidToBinary(ownerCompanyGuid);
			SET @accountGuidBinary = PARCEL.guidToBinary(accountGuid);
			SET @templateGuidBinary = PARCEL.guidToBinary(templateGuid);
			
			INSERT INTO PARCEL.Template (
			             Name,
			             StandardizedTemplateName,
							 OwnerCompanyID,
			             CreatedAccountID,
			             ReportTypeID,
			             ShortName,
			             Description,
			             TemplateDocument,
			             IsMobile,
			             TemplateVersion,
			             OwnerCompanyGuidBinary,
			             CreatedAccountGuidBinary,
			             TemplateGuidBinary
										       ) 
			VALUES (
							 name,
							 standardizedName,
							 ownerCompanyID,
							 accountID,
							 newReportTypeID,
							 newShortName, 
							 newDescription,
							 newTemplateDocument,
							 newIsMobile,
			             newTemplateVersion,
			             @ownerCompanyGuidBinary,
			             @accountGuidBinary,
							 @templateGuidBinary);
			
			SELECT LAST_INSERT_ID() INTO @newTemplateID;
			
			
			
			/* Insert the Template sections associated with a template to the Template Section table for the newly copied template */
			
		   INSERT INTO PARCEL.TemplateSection (SectionStructure, SectionID, TemplateID)						       
		   SELECT       ts.SectionStructure,
		                ts.SectionID,
		                @newTemplateID
		   FROM  PARCEL.TemplateSection ts
			WHERE ts.TemplateID = @templateID;
		   
		  /* Retrieve the new template attribute details copied from an existing template */
		  CALL PARCEL.getTemplateDetail(templateGuid); 
		  
		  
		ELSE 
		   /* Throws an error, if an active exisitng template is used */
		   CALL PARCEL.getErrorMessage('template_name_conflict', error_message);
		   SIGNAL template_name_conflict 
		      SET MESSAGE_TEXT = error_message;
		
		END IF;

COMMIT;

END //
Delimiter ;