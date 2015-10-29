Delimiter //
DROP PROCEDURE IF EXISTS deleteTemplate;
CREATE  PROCEDURE `deleteTemplate`(IN `templateGuid` VARCHAR(32), 
                                   IN `accountGuid` VARCHAR(32),
											  IN `accountID` BIGINT)
	
	COMMENT 'Deleting an existing Template for a particular company'
BEGIN
       SET @accountGuidBinary = PARCEL.guidToBinary(accountGuid);
       SET @templateGuidBinary = PARCEL.guidToBinary(templateGuid);
		 UPDATE PARCEL.Template t
		 SET t.IsTemplateDisabled = 1,
		     t.StandardizedTemplateName = NULL, 
    		  t.DeletedAccountID = accountID,
    		  t.DeletedAccountGuidBinary = @accountGuidBinary,
			  t.DeletedTimestamp = CURRENT_TIMESTAMP()
		 WHERE t.TemplateGuidBinary = @templateGuidBinary;
			  
END //
Delimiter ;