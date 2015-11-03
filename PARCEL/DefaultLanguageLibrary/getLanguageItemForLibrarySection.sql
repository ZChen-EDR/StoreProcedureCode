Delimiter //
DROP PROCEDURE IF EXISTS getLanguageItemForLibrarySection;
CREATE PROCEDURE getLanguageItemForLibrarySection(IN sectionGuid VARCHAR(32),
                                                  IN libraryGuid VARCHAR(32))
BEGIN
     SET @sectionGuidBinary = PARCEL.guidToBinary(sectionGuid);
     SET @libraryGuidBinary = PARCEL.guidToBinary(libraryGuid);
      
     SELECT  dli.SectionID as sectionID,
		       dli.DefaultLanguageItemID as defaultLanguageItemID,
		       PARCEL.binaryToGuid(dli.DefaultLanguageItemGuidBinary) as defaultLangugeItemGuid,
				 dli.LanguageText as languageText,
             lcv.LocalCodeValueID as categoryCodeID,
				 lcv.CodeValueShortName as categoryValue,
				 lcv.CodeValueName as categoryName,
				 dli.TitleKeyword as titleKeyword,
				 dli.ShowInPage as showInPage,
				 dli.OrderIndex as orderIndex 
     FROM PARCEL.Section ps,
          PARCEL.DefaultLanguageLibrary dll,
          PARCEL.DefaultLanguageItem dli
          LEFT JOIN
          PARCEL.LocalCodeValue lcv ON dli.CategoryTypeCode = lcv.LocalCodeValueID
     WHERE 
           dll.DefaultLanguageLibraryID = dli.DefaultLanguageLibraryID AND
           ps.SectionID = dli.SectionID AND
           ps.SectionGuidBinary = @sectionGuidBinary AND
           dli.IsDefaultLanguageItemDeactivated = 0 AND
           dll.DefaultLanguageLibaryGuidBinary = @libraryGuidBinary;
           


END //
Delimiter ;                