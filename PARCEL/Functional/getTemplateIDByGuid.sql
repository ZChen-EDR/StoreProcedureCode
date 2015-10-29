Delimiter //
DROP FUNCTION IF EXISTS getTemplateIDByGuid;
CREATE FUNCTION getTemplateIDByGuid(templateGuid VARCHAR(32))
RETURNS BIGINT
BEGIN 
      SET @templateGuidBinary = PARCEL.guidToBinary(templateGuid);
      SELECT pt.TemplateID
		INTO @templateID
		FROM PARCEL.Template pt
		WHERE pt.TemplateGuidBinary = @templateGuidBinary;
		
		RETURN @templateID;
END //
Delimiter ;   