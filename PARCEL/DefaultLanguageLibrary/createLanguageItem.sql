Delimiter //
DROP PROCEDURE IF EXISTS createLanguageItem;
CREATE PROCEDURE createLanguageItem( IN langugageItemGuid VARCHAR(32),
	                                  IN languageText TEXT,
												 IN category ENUM('OPTIONS','INSTRUCTIONS','SAMPLE'),
												 IN titleKeyword VARCHAR(256),
												 IN showInPage TinyInt,
												 IN accountID BIGINT,
												 IN accountGuid VARCHAR(32),
												 IN libraryGuid VARCHAR(32),
												 IN sectionGuid VARCHAR(32))
BEGIN 
      
      DECLARE codeTableID INT;
      DECLARE EXIT HANDLER FOR SQLEXCEPTION 
			  BEGIN
				   GET DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
				   SELECT @p1,@p2;
				   
				   ROLLBACK;
			  
			  END;
START TRANSACTION;
      SET codeTableID = 7;
      
      
      SET @accountGuidBinary = PARCEL.guidToBinary(accountGuid);
      SET @itemGuidBinary = PARCEL.guidToBinary(langugageItemGuid);
      SET @libraryGuidBinary = PARCEL.guidToBinary(libraryGuid);
      SET @sectionGuidBinary = PARCEL.guidToBinary(sectionGuid);
      

      IF category != null THEN
         SELECT lcv.LocalCodeValueID
         INTO @categoryID
         FROM PARCEL.LocalCodeValue lcv,
              PARCEL.LocalCodeTable lct
         WHERE lct.LocalCodeTableID = codeTableID  AND
               lct.LocalCodeTableID = lcv.LocalCodeTableID AND
			      lcv.CodeValueShortName = category;
			SELECT @category;
		END IF;
            
      
      
      INSERT INTO PARCEL.DefaultLanguageItem     (DefaultLanguageItemGuidBinary,
                                                  LanguageText,
                                                  CategoryTypeCode,
                                                  TitleKeyword,
                                                  ShowInPage,
                                                  CreatedAccountID,
                                                  CreatedAccountGuidBinary)
                                          VALUES
                                                  (@itemGuidBinary,
                                                   languageText,
                                                   @categoryID,
                                                   titleKeyword,
                                                   showInPage,
                                                   accountID,
                                                   @accountGuidBinary);
      
      SELECT LAST_INSERT_ID() INTO @languageItemID;
      
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
      
      #insert into relationship
      INSERT INTO PARCEL.DefaultLanguageItemLibrary (DefaultLanguageLibraryID,
                                                     DefaultLanguageItemID,
                                                     SectionID)
                                             VALUES
	                                                   (@libraryID,
																		 @languageItemID,
	                                                    @sectionID);
      
      
      
      CALL PARCEL.getLanguageItem(langugageItemGuid);
                                                   
                                          
                                                   
COMMIT;                                          

END //
Delimiter ;