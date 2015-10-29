Delimiter //
DROP PROCEDURE IF EXISTS getTemplateDetail;
CREATE  PROCEDURE `getTemplateDetail`(IN `templateGuid` VARCHAR(32))
	
	COMMENT 'Retrieve the details for a Template'
BEGIN
	SET @templateGuidBinary = PARCEL.guidToBinary(templateGuid);
	/*template general information*/
	SELECT t.TemplateID AS templateID,
	       PARCEL.binaryToGuid(t.TemplateGuidBinary) as templateGuid,
	       t.Name AS name,
			 t.OwnerCompanyID AS ownerCompanyID,
	       PARCEL.binaryToGuid(t.OwnerCompanyGuidBinary) AS ownerCompanyGuid, 
			 t.ShortName AS shortName,
			 t.Description AS description,
			 rt.Value AS 'reportTypeValue',
			 rt.Name AS 'reportTypeName',
			 t.IsMobile AS isMobile,
			 t.TemplateVersion AS templateVersion
	FROM   PARCEL.Template t
	JOIN   PARCEL.ReportType rt ON  t.ReportTypeID = rt.ReportTypeID
	WHERE  t.TemplateGuidBinary = @templateGuidBinary;


END //
Delimiter ;