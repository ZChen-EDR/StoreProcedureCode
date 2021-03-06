Delimiter //
DROP PROCEDURE IF EXISTS copyLanguageItemToHistory;
CREATE PROCEDURE copyLanguageItemToHistory(  IN accountID BIGINT,
                                             IN accountGUIDBinary Binary(16),
                                             IN languageGuidBinary Binary(16))
BEGIN
       SET @accountID = accountID;
       SET @accountGuidBinary = accountGUIDBinary;

       INSERT INTO PARCEL.DefaultLanguageItemHistory (DefaultLanguageItemID,
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
