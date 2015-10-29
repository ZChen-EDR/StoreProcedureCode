Delimiter //
DROP PROCEDURE IF EXISTS getTemplateDefaultConfig;
CREATE  PROCEDURE `getTemplateDefaultConfig`(IN `templateGuid` VARCHAR(32),
															IN `ownerCompanyGuid` VARCHAR(32))

	COMMENT 'Retrieve Template default configuration'
BEGIN

		SET @templateGuidBinary = PARCEL.guidToBinary(templateGuid);
		SET @ownerCompanyGuidBinary = PARCEL.guidToBinary(ownerCompanyGuid);
		
		Select t.TemplateID
		INTO @templateID
		FROM PARCEL.Template t
		WHERE t.TemplateGuidBinary = @templateGuidBinary;
		
		SELECT tca.ObjectID
		INTO @ownerCompanyID
		FROM PARCEL.TemporayCompanyAccountGuid tca
		WHERE tca.`Type` = 'Company' AND tca.Guid = templateGuid;
		 
		/*report out put setup (reportoutput, transmittal letter, table of content)*/
		SELECT rost.ReportOutputSetupID, lcv.CodeValueName AS setupType
		
		FROM   PARCEL.Template t
		JOIN   PARCEL.ReportOutputSetupTemplate rost ON t.TemplateID = rost.TemplateID
		JOIN   PARCEL.ReportOutputSetup ros ON ros.ReportOutputSetupID = rost.ReportOutputSetupID
		JOIN   PARCEL.LocalCodeValue lcv ON lcv.LocalCodeValueID = ros.ReportSetupTypeCode
		JOIN   PARCEL.LocalCodeTable lct ON lct.LocalCodeTableID = lcv.LocalCodeTableID
		
		WHERE  (t.TemplateGuidBinary = @templateGuidBinary AND 
		        rost.OwnerCompanyGuidBinary = @ownerCompanyGuidBinary  AND lct.CodeTableName = 'ReportSetupType');
		
		
		
		/*cover page template*/       
		SELECT cct.CompanyCoverTemplateID as coverPageTemplateID,
		       cct.CompanyCoverTemplateGuidBinary as coverPageTemplateGuid,
		       cct.Name as coverPageName
		FROM PARCEL.CompanyCoverTemplate cct,
		     PARCEL.CompanyCoverPageTemplate ccpt,
		     PARCEL.Template t
		WHERE t.TemplateID = ccpt.TemplateID AND
		      cct.CompanyCoverTemplateID = ccpt.CompanyCoverTemplateID AND
		      t.TemplateGuidBinary = @templateGuidBinary AND
		      ccpt.OwnerCompanyGuidBinary = @ownerCompanyGuidBinary;
		
		/*language library id*/       
		SELECT dllt.DefaultLanguageLibraryID AS languageLibraryID
		
		FROM   PARCEL.Template t
		JOIN   PARCEL.DefaultLanguageLibraryTemplate dllt ON t.TemplateID = dllt.TemplateID
		
		WHERE  (dllt.TemplateID = @templateID AND dllt.OwnerCompanyID = @ownerCompanyID);

END //
Delimiter ;