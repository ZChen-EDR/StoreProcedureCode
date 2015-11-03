Delimiter //
DROP PROCEDURE IF EXISTS updateLanguageLibraryItem;
CREATE PROCEDURE updateLanguageLibraryItem(IN langugageItemGuid VARCHAR(32),
                                           IN languageText TEXT,
														 IN categoryID INT,
														 IN titleKeyword VARCHAR(256),
														 IN showInPage TinyInt,
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
      SET @languageItemGuidBinary = PARCEL.guidToBinary(langugageItemGuid);
      SET @accountGuidBinary = PARCEL.guidToBinary(langugageItemGuid);
      
      
      #Copy the item into History Table
      CALL PARCEL.copyLanguageItemToHistory(accountID, @accountGuidBinary, @languageItemGuidBinary,@itemHistoryID);
      
      
      #now doing the work
      UPDATE PARCEL.DefaultLanguageItem dli
      SET dli.LanguageText = languageText,
          dli.CategoryTypeCode = categoryID,
          dli.TitleKeyword = titleKeyword,
          dli.ShowInPage = showInPage,
          dli.ModifiedAccountID = accountID,
          dli.ModifiedAccountGuidBinary = @accountGuidBinary,
          dli.ModifiedTimestamp = CURRENT_TIME()
      WHERE dli.DefaultLanguageItemGuidBinary = @languageItemGuidBinary;
      
      CALL PARCEL.getLanguageItem(langugageItemGuid);

COMMIT;
END //
Delimiter ;
