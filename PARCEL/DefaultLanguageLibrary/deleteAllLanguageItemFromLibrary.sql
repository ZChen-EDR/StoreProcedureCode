Delimiter //
DROP PROCEDURE IF EXISTS deleteAllLanguageItemFromLibrary;
CREATE PROCEDURE `deleteAllLanguageItemFromLibrary`(IN `libraryGuid` VARCHAR(32), 
                                                    IN `accountGuid` VARCHAR(32), 
																	 IN `accountID` BIGINT)
	
	COMMENT 'empty the library, caution, but it\'s actually ok, we can easily flip it back'
BEGIN
    
    SET @libraryGuid = PARCEL.guidToBinary(libraryGuid);
    SET @accountGuid = PARCEL.guidToBinary(accountGuid);
   

    UPDATE PARCEL.DefaultLanguageItem dli,
           PARCEL.DefaultLanguageItemLibrary dlil,
           PARCEL.DefaultLanguageLibrary dll
    SET dli.IsDefaultLanguageItemDeactivated = 1,
        dli.DeletedAccountGuidBinary = @accountGuid,
        dli.DeletedAccountID = accountID,
        dli.DeletedTimestamp = CURRENT_TIME()
    WHERE dlil.DefaultLanguageItemID = dli.DefaultLanguageItemID AND
          dlil.DefaultLanguageLibraryID = dll.DefaultLanguageLibraryID AND
          dll.DefaultLanguageLibaryGuidBinary = @libraryGuid;

END //
Delimiter ;