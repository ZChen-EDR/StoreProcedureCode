Delimiter //
DROP PROCEDURE IF EXISTS deleteAllLanguageItemFromLibrary;
CREATE PROCEDURE `deleteAllLanguageItemFromLibrary`(IN `libraryGuid` VARCHAR(32), 
                                                    IN `accountGuid` VARCHAR(32), 
																	 IN `accountID` BIGINT)
	
	COMMENT 'empty the library, caution, but it\'s actually ok, we can easily flip it back'
BEGIN
          DECLARE EXIT HANDLER FOR SQLEXCEPTION 
			  BEGIN
				   GET DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
				   SELECT @p1,@p2;
				   
				   ROLLBACK;
			  
			  END;
START TRANSACTION;
    
    
    SET @libraryGuid = PARCEL.guidToBinary(libraryGuid);
    SET @accountGuid = PARCEL.guidToBinary(accountGuid);
    
    SELECT dll.DefaultLanguageLibraryID
    INTO @libraryID
    FROM PARCEL.DefaultLanguageLibrary dll
    WHERE dll.DefaultLanguageLibaryGuidBinary = @libraryGuid;
   
    CALL PARCEL.copyAllLanguageItemToDeleted(accountID,@accountGuid,@libraryID);
    
    

    DELETE 
    FROM PARCEL.DefaultLanguageItem 
    WHERE DefaultLanguageLibraryID = @libraryID;

COMMIT;

END //
Delimiter ;