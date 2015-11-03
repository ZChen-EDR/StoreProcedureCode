Delimiter //
DROP PROCEDURE IF EXISTS createLanguageItem;
CREATE PROCEDURE createLanguageItem( IN langugageItemGuid VARCHAR(32),
	                                  IN languageText TEXT,
												 IN categoryID BIGINT,
												 IN titleKeyword VARCHAR(256),
												 IN showInPage TinyInt,
												 IN accountID BIGINT,
												 IN accountGuid VARCHAR(32),
												 IN libraryGuid VARCHAR(32),
												 IN sectionGuid VARCHAR(32))
BEGIN 
      
      
      DECLARE EXIT HANDLER FOR SQLEXCEPTION 
			  BEGIN
				   GET DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
				   SELECT @p1,@p2;
				   
				   ROLLBACK;
			  
			  END;
START TRANSACTION;
      
      
      SET @accountGuidBinary = PARCEL.guidToBinary(accountGuid);
      SET @itemGuidBinary = PARCEL.guidToBinary(langugageItemGuid);
      SET @libraryGuidBinary = PARCEL.guidToBinary(libraryGuid);
      SET @sectionGuidBinary = PARCEL.guidToBinary(sectionGuid);
            
      #get sectionID
      SELECT s.SectionID
      INTO @sectionID
      FROM PARCEL.Section s
      WHERE s.SectionGuidBinary = @sectionGuidBinary;
      
      
      #get libraryID
      SELECT dll.DefaultLanguageLibraryID
      INTO @libraryID
      FROM PARCEL.DefaultLanguageLibrary dll
      WHERE dll.DefaultLanguageLibaryGuidBinary = @libraryGuidBinary;
      
      INSERT INTO PARCEL.DefaultLanguageItem     (DefaultLanguageItemGuidBinary,
                                                  LanguageText,
                                                  CategoryTypeCode,
                                                  TitleKeyword,
                                                  ShowInPage,
                                                  CreatedAccountID,
                                                  CreatedAccountGuidBinary,
																  SectionID,
																  DefaultLanguageLibraryID)
                                          VALUES
                                                  (@itemGuidBinary,
                                                   languageText,
                                                   categoryID,
                                                   titleKeyword,
                                                   showInPage,
                                                   accountID,
                                                   @accountGuidBinary,
																	@sectionID,
																	@libraryID);
      
      CALL PARCEL.getLanguageItem(langugageItemGuid);
                                                   
                                          
                                                   
COMMIT;                                          

END //
Delimiter ;