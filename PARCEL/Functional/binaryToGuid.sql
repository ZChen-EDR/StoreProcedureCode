Delimiter //
CREATE FUNCTION binaryToGuid(guidBinary BINARY(16))
RETURNS VARCHAR(32)
BEGIN 
      DECLARE result VARCHAR(32);
      SET result = HEX(guidBinary);
		RETURN result;
END //
Delimiter ;