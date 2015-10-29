Delimiter //
DROP PROCEDURE IF EXISTS getTemplateListByCompany;
CREATE  PROCEDURE `getTemplateListByCompany`(IN `ownerCompanyGuid` VARCHAR(32))

	COMMENT 'Retrieve list of templates for a particular company'
BEGIN
   SET @ownerCompanyGuidBinary = PARCEL.guidToBinary(ownerCompanyGuid);
   SELECT  t.TemplateID AS templateID,
	        PARCEL.binaryToGuid(t.TemplateGuidBinary) AS templateGuid,
	        t.Name AS name,
			  t.ShortName AS shortName,
			  t.Description AS description,
			  rt.Value AS reportTypeValue,
			  rt.Name AS reportTypeName,
			  t.IsMobile AS isMobile,
			  t.TemplateVersion AS templateVersion,
	        ct.ConsultantCompanyID AS ownerCompanyID,
	        PARCEL.binaryToGuid(t.OwnerCompanyGuidBinary) AS ownerCompanyGuid 
	        
	FROM    PARCEL.Template t
	LEFT JOIN PARCEL.CompanyTemplate ct ON t.TemplateID = ct.TemplateID
	JOIN   PARCEL.ReportType rt ON  t.ReportTypeID = rt.ReportTypeID
	WHERE t.IsTemplateDisabled = 0 AND 
	     (t.OwnerCompanyGuidBinary = @ownerCompanyGuidBinary OR ct.ConsultantCompanyID = ownerCompanyID OR t.OwnerCompanyID = 0);

END //
Delimiter ;