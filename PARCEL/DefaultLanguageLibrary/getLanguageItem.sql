Delimiter //
DROP PROCEDURE IF EXISTS getLanguageItem;
CREATE PROCEDURE getLanguageItem(IN languageItemGuid VARCHAR(32))
BEGIN
     SET @itemGuidBinary = PARCEL.guidToBinary(languageItemGuid);
     
     SELECT   dli.DefaultLanguageItemID as defaultLanguageItemID,
	           dli.DefaultLanguageItemGuidBinary as defaultLanguageItemGuid,
	           dli.LanguageText as languageText,
	           lcv.LocalCodeValueID as categoryID,
	           lcv.CodeValueShortName as categoryValue,
	           lcv.CodeValueName as categoryName,
	           dli.TitleKeyword as titleKeyword,
	           dli.ShowInPage as showInPage,
	           dli.OrderIndex as orderIndex,
	           dli.ModifiedTimestamp as lastModifiedTimestamp,
	           dli.SectionID as sectionID,
              dli.DefaultLanguageLibraryID as defaultLanguageLibraryID
           
     FROM PARCEL.DefaultLanguageItem dli 
			 LEFT JOIN
          PARCEL.LocalCodeValue lcv on dli.CategoryTypeCode = lcv.LocalCodeValueID
     WHERE dli.DefaultLanguageItemGuidBinary = @itemGuidBinary;

END //
Delimiter ;