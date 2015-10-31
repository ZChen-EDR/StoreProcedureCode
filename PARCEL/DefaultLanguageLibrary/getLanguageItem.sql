Delimiter //
DROP PROCEDURE IF EXISTS getLanguageItem;
CREATE PROCEDURE getLanguageItem(IN languageItemGuid VARCHAR(32))
BEGIN
     SET @itemGuidBinary = PARCEL.guidToBinary(languageItemGuid);
     
     SELECT   dli.DefaultLanguageItemID as defaultLanguageItemID,
	           dli.DefaultLanguageItemGuidBinary as defaultLanguageItemGuid,
	           dli.LanguageText as languageText,
	           lcv.CodeValueShortName as categoryValue,
	           lcv.CodeValueName as categoryName,
	           dli.TitleKeyword as titleKeyword,
	           dli.ShowInPage as showInPage,
	           dli.OrderIndex as orderIndex,
	           dli.ModifiedTimestamp as lastModifiedTimestamp
           
     FROM PARCEL.DefaultLanguageItem dli 
			 LEFT JOIN
          PARCEL.LocalCodeValue lcv on dli.CategoryTypeCode = lcv.LocalCodeValueID
     WHERE dli.DefaultLanguageItemGuidBinary = @itemGuidBinary;

END //
Delimiter ;