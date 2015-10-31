Delimiter //
DROP PROCEDURE IF EXISTS updateLanguageLibraryDetail;
CREATE  PROCEDURE `updateLanguageLibraryDetail`(IN `libraryGuid` VARCHAR(32), 
                                                IN `name` VARCHAR(256), 
																IN `defaultTemplateID` BIGINT, 
																IN `accountID` BIGINT,
																IN `accountGuid` VARCHAR(32))
	COMMENT 'Update the existing Langauge Library detail'
BEGIN

		DECLARE standardizedName VARCHAR(256);
		DECLARE error_message VARCHAR(256);
		DECLARE IsValid TINYINT;
		DECLARE DLL_name_conflict CONDITION FOR SQLSTATE '45000';
		
		SET standardizedName = UPPER(TRIM(name));
		SET @libraryGuidBinary = PARCEL.guidToBinary(libraryGuid);
		SET @accountGuidBinary = PARCEL.guidToBinary(accountGuid);
		
		/*change the standardized name to null before updating*/
		UPDATE PARCEL.DefaultLanguageLibrary dll
		SET dll.StandardizedLibraryName = null
		WHERE dll.DefaultLanguageLibaryGuidBinary = @libraryGuidBinary;
		
		/* This is to check, if the library name already exists for the same company */
		SELECT dll.OwnerCompanyID
		INTO @ownerCompanyID
		FROM PARCEL.DefaultLanguageLibrary dll
		WHERE dll.DefaultLanguageLibaryGuidBinary = @libraryGuidBinary;
		
		SELECT PARCEL.checkValidLibraryName(standardizedName, @ownerCompanyID)
		
		INTO IsValid;
		
		IF IsValid = 1 THEN 
		
		
			UPDATE PARCEL.DefaultLanguageLibrary defl
			SET 	 defl.Name = name,
					 defl.StandardizedLibraryName = standardizedName,
					 defl.ModifiedAccountID = accountID,
					 defl.ModifiedAccountGuidBinary = @accountGuidBinary,
					 defl.DerivedFromTemplateID = defaultTemplateID,
					 defl.ModifiedTimestamp = current_time()
			WHERE  defl.DefaultLanguageLibaryGuidBinary = @libraryGuidBinary;
			
			/* Retrieve the new template attribute details updated for an existing Library */
			
			CALL PARCEL.getLanguageLibraryDetail(libraryGuid);
		
		ELSE 
		
		/* Throws an error for the validation check */
		
		CALL PARCEL.getErrorMessage('DLL_name_conflict', error_message);
			SIGNAL DLL_name_conflict
			SET MESSAGE_TEXT = error_message;
		
		END IF;

END //
Delimiter ;