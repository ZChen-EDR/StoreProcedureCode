Delimiter //
DROP PROCEDURE IF EXISTS getLanguageItemForLibrarySection;
CREATE PROCEDURE getLanguageItemForLibrarySection(IN sectionGuid VARCHAR(32),
                                                  IN libraryGuid VARCHAR(32))
BEGIN
     SET @sectionGuidBinary = PARCEL.guidToBinary(sectionGuid);
     SET @libraryGuidBinary = PARCEL.guidToBinary(libraryGuid);
      
     SELECT  dlil.SectionID as sectionID,
		       dli.DefaultLanguageItemID as defaultLanguageItemID,
		       PARCEL.binaryToGuid(dli.DefaultLanguageItemGuidBinary) as defaultLangugeItemGuid,
				 dli.LanguageText as languageText,
             lcv.LocalCodeValueID as categoryCodeID,
				 lcv.CodeValueShortName as categoryValue,
				 lcv.CodeValueName as categoryName,
				 dli.TitleKeyword as titleKeyword,
				 dli.ShowInPage as showInPage,
				 dli.OrderIndex as orderIndex 
     FROM PARCEL.DefaultLanguageItem dli,
          PARCEL.DefaultLanguageItemLibrary dlil,
          PARCEL.Section ps,
          PARCEL.DefaultLanguageLibrary dll,
          PARCEL.LocalCodeValue lcv
     WHERE dli.DefaultLanguageItemID = dlil.DefaultLanguageItemID AND
           dll.DefaultLanguageLibraryID = dlil.DefaultLanguageLibraryID AND
           ps.SectionID = dlil.SectionID AND
           dli.CategoryTypeCode = lcv.LocalCodeValueID AND
           ps.SectionGuidBinary = @sectionGuidBinary AND
           dli.IsDefaultLanguageItemDeactivated = 0 AND
           dll.DefaultLanguageLibaryGuidBinary = @libraryGuidBinary;
           


END //
Delimiter ;                