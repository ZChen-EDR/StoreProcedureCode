Delimiter //
DROP PROCEDURE IF EXISTS deleteDefaultLanguageItem;
CREATE PROCEDURE deleteDefaultLanguageItem(IN languageItemGuid VARCHAR(32),
                                           IN accountID BIGINT,
														 IN accountGuid VARCHAR(32))

BEGIN
     DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	  BEGIN
		   GET DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
		   SELECT @p1,@p2;
		   
		   ROLLBACK;
	  
	  END;
      
START TRANSACTION;  
    
    SET @itemGuidBinary = PARCEL.guidToBinary(languageItemGuid);
    SET @accountGuidBinary = PARCEL.guidToBinary(accountGuid);
    
    CALL PARCEL.copyLanguageItemToDeleted(accountID, @accountGUIDBinary, @itemGuidBinary);
    
    DELETE
    FROM PARCEL.DefaultLanguageItem
    WHERE DefaultLanguageItemGuidBinary = @itemGuidBinary;
    

COMMIT;

END //
Delimiter ;
