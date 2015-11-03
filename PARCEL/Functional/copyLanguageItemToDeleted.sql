Delimiter //
CREATE  PROCEDURE `copyLanguageItemToDeleted`(IN `accountID` BIGINT, 
                                              IN `accountGUIDBinary` Binary(16), 
															 IN `languageGuidBinary` Binary(16))
	COMMENT ''
BEGIN
       SET @accountID = accountID;
       SET @accountGuidBinary = accountGUIDBinary;

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
                                             WHERE dli.DefaultLanguageItemGuidBinary = languageGuidBinary;

END //
Delimiter ;