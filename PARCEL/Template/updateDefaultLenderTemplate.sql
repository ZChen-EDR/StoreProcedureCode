Delimiter //
DROP PROCEDURE IF EXISTS updateDefaultLenderTemplate;
CREATE  PROCEDURE `updateDefaultLenderTemplate`(IN `consultantCompanyGuid` VARCHAR(32), 
                                                IN `clientCompanyGuid` VARCHAR(32), 
																IN `templateGuid` VARCHAR(32))
	
	COMMENT 'This procedure will update the default lender template based on the report type'
BEGIN  
       
		 
		 SET @templateGuidBinary = PARCEL.guidToBinary(templateGuid);      
       SET @conCompanyGuidBinary = PARCEL.guidToBinary(consultantCompanyGuid);
		 SET @cliCompanyGuidBinary = PARCEL.guidToBinary(clientCompanyGuid); 
		 
		      
       SELECT pt.TemplateID, rt.ReportTypeID
       INTO @templateID, @reportTypeID
       FROM PARCEL.Template pt,
            PARCEL.ReportType rt
       WHERE rt.ReportTypeID = pt.ReportTypeID AND
		       pt.TemplateGuidBinary = @templateGuidBinary;
       
      
       UPDATE PARCEL.DefaultLenderTemplate dlt
		       JOIN PARCEL.Template pt ON pt.TemplateID = dlt.TemplateID
            
		 SET dlt.TemplateID = @templateID
		 WHERE dlt.ConsultantCompanyGuidBinary = @conCompanyGuidBinary AND
		       dlt.ClientCompanyGuidBinary = @cliCompanyGuidBinary AND
				 pt.ReportTypeID = @reportTypeID;
		       
END //
Delimiter ;