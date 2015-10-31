Delimiter //
DROP PROCEDURE IF EXISTS deleteDefaultLanguageItem;
CREATE PROCEDURE deleteDefaultLanguageItem(IN languageItemGuid VARCHAR(32),
                                           IN accountID BIGINT,
														 IN accountGuid VARCHAR(32))

BEGIN
    
    SET @itemGuidBinary = PARCEL.guidToBinary(languageItemGuid);
    SET @accountGuidBinary = PARCEL.guidToBinary(accountGuid);
    
    
    UPDATE PARCEL.DefaultLanguageItem dli
    SET dli.IsDefaultLanguageItemDeactivated = 1,
        dli.DeletedAccountGuidBinary = @accountGuidBinary,
        dli.DeletedAccountID = accountID,
        dli.DeletedTimestamp = CURRENT_TIME()
    WHERE dli.DefaultLanguageItemGuidBinary = @itemGuidBinary;



END //
Delimiter ;
