Delimiter //
DROP PROCEDURE IF EXISTS createNewLibraryFromExistingLibrary;
CREATE PROCEDURE createNewLibraryFromExistingLibrary(IN libraryGuid VARCHAR(32),
                                                     IN accountGuid VARCHAR(32),
                                                     IN accountID BIGINT,
                                                     IN libraryName VARCHAR(32),
                                                     IN ownerCompanyID BIGINT,
                                                     IN ownerCompanyGuid VARCHAR(32))
BEGIN

      @libraryGuidBinary = PARCEL.guidToBinary(libraryGuid);
      @accountGuidBinary = PARCEL.guidToBinary(accountGuid);
      @ownerCompanyGuidBinary = PARCEL.guidToBinary(ownerCompanyGuid);
      @standardizedName = TRIM(UPPER(libraryName));
      @name = libraryName;
      @ownerCompanyID = ownerCompanyID;
      @accountID = accountIDl
      
      
      
      
      SELECT PARCEL.checkValidLibraryName(@standardizedName, ownerCompanyID)
      INTO @isValid;
      
      IF @isValid THEN
              
            #create library
      		INSERT INTO PARCEL.DefaultLanguageLibrary(DefaultLanguageLibaryGuidBinary,
				                                          OwnerCompanyGuidBinary,
																		Name,
																		StandardizedLibraryName,
																		OwnerCompanyID,
																		FromLibraryID,
																		IsMobile,
																		Description,
																		ReportTypeID,
																		CreatedAccountID,
																		CreatedAccountGuidBinary) 
											      		SELECT @libraryGuidBinary,
											      		       @ownerCompanyGuidBinary,
																	 @name,
																	 @standardizedName,
																	 @OwnerCompanyID,
																	 dll.DefaultLanguageLibraryID,
																	 dll.IsMobile,
																	 dll.Description,
																	 dll.ReportTypeID,
																	 @accountID,
																	 @accountGuid)
															 		      
											      		FROM PARCEL.DefaultLanguageLibrary dll
											      		WHERE dll.DefaultLanguageLibaryGuidBinary = @libraryGuidBinary;
											      		
				SELECT LAST_INSERT_ID() INTO @newLibraryID;
				
				SELECT dll.DefaultLanguageLibraryID
				INTO @sourceLibraryID											 		      
      		FROM PARCEL.DefaultLanguageLibrary dll
      		WHERE dll.DefaultLanguageLibaryGuidBinary = @libraryGuidBinary;
      		
      		CREATE TEMPORARY TABLE ID_GUID(
      		`libraryID` BIGINT(20) NOT NULL,
				`ConsultantCompanyID` BIGINT(20) NULL DEFAULT NULL,
				`TemplateID` BIGINT(20) NULL DEFAULT NULL,
      		
      		
      		
      		#create languageItem
      		INSERT INTO PARCEL.DefaultLanguageItem(DefaultLanguageItemGuidBinary,
				                                       CategoryTypeCode,
																   DefaultLanguageLibraryID,
																	SectionID,
																	LanguageText,
																	TitleKeyword,
																	ShowInPage,
																	OrderIndex,
																	CreatedAccountID,
																	CreatedAccountGuidBinary) 
										      		SELECT PARCEL.guidToBinary(MD5(UUID())),
										      		       dli.CategoryTypeCode,
										      		       @newLibraryID,
										      		       dli.SectionID,
										      		       dli.LanguageText,
										      		       dli.TitleKeyword,
										      		       dli.ShowInPage,
										      		       dli.OrderIndex,
										      		       @accountID,
										      		       @accountGuidBinary
										      		FROM PARCEL.DefaultLanguageItem dli
										      		WHERE dll.LinkedLibraryID = @sourceLibrayID;
      		
				



END //
Delimiter ;