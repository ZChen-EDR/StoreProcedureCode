Delimiter //
DROP PROCEDURE IF EXISTS createNewLanguageLibrary;
CREATE PROCEDURE createNewLanguageLibrary(IN libraryGuid VARCHAR(32),
                                          IN `name` VARCHAR(256), 
														IN `defaultTemplateID` BIGINT, 
														IN `copiedFromLibraryID` BIGINT,
														IN `linkedLibraryID` BIGINT,
														IN `ownerCompanyGuid` VARCHAR(32),
														IN `ownerCompanyID` BIGINT,
														IN `isMobile` TINYINT,
														IN `description` VARCHAR(256),
														IN `reportTypeID` INT,
														IN `accountID` BIGINT,
														IN `accountGuid` VARCHAR(32))
BEGIN   
        DECLARE DLL_name_conflict CONDITION FOR SQLSTATE '45000'; 
        DECLARE error_message VARCHAR(256);

        SET @standardizedName = TRIM(UPPER(name));
        SET @libraryGuidBinary = PARCEL.guidToBinary(libraryGuid);
        SET @ownerCompanyGuidBinary = PARCEL.guidToBinary(ownerCompanyGuid);
        SET @accountGuid = PARCEL.guidToBinary(accountGuid);
        
        
        
        SELECT PARCEL.checkValidLibraryName(@standardizedName, ownerCompanyID)
        INTO @isValid;

        IF @isValid THEN

			        INSERT INTO PARCEL.DefaultLanguageLibrary(DefaultLanguageLibaryGuidBinary,
			                                                  Name,
			                                                  StandardizedLibraryName,
			                                                  OwnerCompanyGuidBinary,
			                                                  OwnerCompanyID,
			                                                  Description,
			                                                  FromLibraryID,
			                                                  IsMobile,
			                                                  CreatedAccountID,
			                                                  CreatedAccountGuidBinary,
			                                                  LinkedLibraryID,
			                                                  ReportTypeID,
																			  DerivedFromTemplateID)
			                                       VALUES
			                                                (@libraryGuidBinary,
																			 name,
																			 @standardizedName,
																			 @ownerCompanyGuidBinary,
																			 ownerCompanyID,
																			 description,
																			 copiedFromLibraryID,
																			 isMobile,
																			 accountID,
																			 @accountGuid,
																			 linkedLibraryID,
																			 reportTypeID,
																			 defaultTemplateID);
			ELSE 
				   CALL PARCEL.getErrorMessage('DLL_name_conflict', error_message);
				   SIGNAL DLL_name_conflict 
				      SET MESSAGE_TEXT = error_message;

			END IF;
                                                  
         

END //
Delimiter ;