Delimiter //
DROP PROCEDURE IF EXISTS deleteLanguageLibrary;
CREATE  PROCEDURE `deleteLanguageLibrary`(IN `libraryGuid` VARCHAR(32), 
                                          IN `accountGuid` VARCHAR(32),
														IN accountID BIGINT)
	COMMENT 'Deletes a particular Language Library'
BEGIN
SET @accountGuidBinary = PARCEL.guidToBinary(accountGuid);
SET @libraryGuid = PARCEL.guidToBinary(libraryGuid);

UPDATE PARCEL.DefaultLanguageLibrary defl

		SET defl.IsLibraryDisabled = 1,
		    defl.StandardizedLibraryName = NULL,
		    defl.DeletedAccountID = accountID,
		    defl.DeletedAccountGuidBinary = @accountGuidBinary,
		    defl.DeletedTimestamp = CURRENT_TIMESTAMP
	 WHERE defl.DefaultLanguageLibaryGuidBinary = @libraryGuid;
		

END //
Delimiter ;