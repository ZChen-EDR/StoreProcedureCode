Delimiter //
CREATE  PROCEDURE `copyAllLanguageItemToDeleted`(IN `accountID` BIGINT, 
	                                              IN `accountGUIDBinary` Binary(16), 
																 IN `languageLibraryGuid` Binary(16))
	COMMENT ''
BEGIN
       SET @accountID = accountID;
       SET @accountGuidBinary = accountGUIDBinary;
       
       SELECT dll.DefaultLanguageLibraryID
       INTO @libraryID
       FROM PARCEL.DefaultLanguageLibrary dll
       WHERE dll.DefaultLanguageLibaryGuidBinary = languageLibraryGuid;

       INSERT INTO PARCEL.DefaultLanguageItemDeleted (DefaultLanguageItemID,
                                                      DefaultLanguageItemGuidBinary,
                                                      LanguageText,
                                                      CategoryTypeCode,
                                                      TitleKeyword,
                                                      ShowInPage,
                                                      OrderIndex,
                                                      CreatedAccountID,
                                                      CreatedAccountGuidBinary,
																		SectionID,
																		DefaultLanguageLibraryID)
                                             SELECT dli.DefaultLanguageItemID,
                                                    dli.DefaultLanguageItemGuidBinary,
                                                    dli.LanguageText,
                                                    dli.CategoryTypeCode,
                                                    dli.TitleKeyword,
                                                    dli.ShowInPage,
                                                    dli.OrderIndex,
                                                    @accountID,
                                                    @accountGuidBinary,
                                                    dli.SectionID,
                                                    dli.DefaultLanguageLibraryID
                                             FROM PARCEL.DefaultLanguageItem dli
                                             WHERE dli.DefaultLanguageLibraryID = @libraryID;

END //
Delimiter ;