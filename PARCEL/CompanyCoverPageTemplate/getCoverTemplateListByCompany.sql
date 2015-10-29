Delimiter //
DROP PROCEDURE IF EXISTS getCoverTemplateListByCompany;
CREATE PROCEDURE getCoverTemplateListByCompany(IN companyGuid VARCHAR(32))
BEGIN
     SET @companyGuidBinary = PARCEL.guidToBinary(companyGuid);
     
     SELECT cct.CompanyCoverTemplateID as coverPageTemplateID,
            PARCEL.binaryToGuid(cct.CompanyCoverTemplateGuidBinary) as coverPageTemplateGuid,
            cct.Name as coverPageTemplateName  
     FROM PARCEL.CompanyCoverTemplate cct
     WHERE cct.OwnerCompanyGuidBinary = @companyGuidBinary OR
			  cct.OwnerCompanyID = 0;
     
END //
Delimiter ;
