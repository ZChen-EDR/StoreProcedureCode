Delimiter //
DROP PROCEDURE IF EXISTS getTemplateFilterList;
CREATE PROCEDURE getTemplateFilterList (IN companyGuid VARCHAR(32))
BEGIN
      SET @companyGuidBinary = PARCEL.guidToBinary(companyGuid);
      SELECT tf.TemplateFilterID as templateFilterID, 
		       tf.Name as name
      FROM PARCEL.TemplateFilter tf
      WHERE tf.OwnerCompanyGuidBinary = @companyGuidBinary;
END //
Delimiter ;