Delimiter //
DROP PROCEDURE IF EXISTS copyItemLibraryRelationshipToHistory;
CREATE PROCEDURE copyItemLibraryRelationshipToHistory(IN languageItemGuidBinary Binary(16),
                                                      IN itemHistoryID BIGINT)
BEGIN 
      SET @itemHistoryID = itemHistoryID;

      #get the id for that guid
		SELECT dli.DefaultLanguageItemID
      INTO @itemID
      FROM PARCEL.DefaultLanguageItem dli
      WHERE dli.DefaultLanguageItemGuidBinary = languageItemGuidBinary;
		    
		    
      INSERT INTO PARCEL.DefaultLanguageItemLibraryHistory      (SectionID,
                                                                 DefaultLanguageLibraryID,
                                                                 DefaultLanguageItemID,
																					  LibraryDefaultLanguageItemID,
																					  DefaultLanguageItemHistoryID)
                                                      SELECT dlil.SectionID,
																		       dlil.DefaultLanguageLibraryID,
																		       dlil.DefaultLanguageItemID,
																		       dlil.LibraryDefaultLanguageItemID,
																		       @itemHistoryID
																		       
                                                      FROM PARCEL.DefaultLanguageItemLibrary dlil
                                                      WHERE dlil.DefaultLanguageItemID = @itemID;
                                                      
END //
Delimiter ;
                                             