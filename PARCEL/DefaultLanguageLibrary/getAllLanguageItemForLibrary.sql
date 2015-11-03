Delimiter //
DROP PROCEDURE IF EXISTS getAllLanguageItemForLibrary;
CREATE  PROCEDURE `getAllLanguageItemForLibrary`(IN libraryGuid VARCHAR(32))
	COMMENT 'Retrieve ALL language entries for every section the library has irrelevent of the template'
BEGIN

/* 'Retrieve ALL language entries for every section the library has irrelevent of the template' */

	SET @libraryGuidBinary = PARCEL.guidToBinary(libraryGuid);
	SELECT dli.SectionID as sectionID,
	       dli.DefaultLanguageItemID as defaultLanguageItemID,
	       PARCEL.binaryToGuid(dli.DefaultLanguageItemGuidBinary) as defaultLangugeItemGuid,
			 dli.LanguageText as languageItem,
			 lcv.CodeValueShortName as categoryValue,
			 lcv.CodeValueName as categoryName,
			 dli.TitleKeyword as titleKeyword,
			 dli.ShowInPage as showInPage,
			 dli.OrderIndex as orderIndex 
	FROM PARCEL.DefaultLanguageLibrary dll,
	     PARCEL.DefaultLanguageItem dli 
	     LEFT JOIN
	     PARCEL.LocalCodeValue lcv ON dli.CategoryTypeCode = lcv.LocalCodeValueID
	WHERE dli.DefaultLanguageLibraryID = dll.DefaultLanguageLibraryID AND
	      dli.IsDefaultLanguageItemDeactivated = 0 AND
			dll.DefaultLanguageLibaryGuidBinary = @libraryGuidBinary;

END //
Delimiter ;