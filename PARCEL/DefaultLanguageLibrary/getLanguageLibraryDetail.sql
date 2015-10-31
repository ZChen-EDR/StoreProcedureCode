Delimiter //
DROP PROCEDURE IF EXISTS getLanguageLibraryDetail;
CREATE PROCEDURE `getLanguageLibraryDetail`(IN `libraryGuid` VARCHAR(32))
	
	COMMENT 'Retrieves the detail information for a specific library'
BEGIN

/* Retrieve all the required attributes for Default Language Library */
SET @libraryGuidBinary = PARCEL.guidToBinary(libraryGuid);

SELECT defl.DefaultLanguageLibraryID AS libraryID,
       defl.Name AS name,
       defl.Description as description,
       defl.ReportTypeID as reportTypeID,
       rt.Name as reportName,
       rt.Value as reportValue,
		 defl.OwnerCompanyID AS ownerCompanyID,
		 PARCEL.binaryToGuid(defl.OwnerCompanyGuidBinary) as ownerCompanyGuid,
		 defl.FromLibraryID AS fromLibraryID,
		 defl.IsLibraryDisabled AS isLibraryDisabled,
		 defl.IsMobile AS isMobile,
		 defl.LinkedLibraryID AS linkedLibraryID,
		 defl.DerivedFromTemplateID AS defaultTemplateID,
		 defl.CreatedAccountID AS creatorAccountID,
		 PARCEL.binaryToGuid(defl.CreatedAccountGuidBinary) as creatorAccountGuid,
		 defl.CreatedTimestamp AS createTimestamp

FROM PARCEL.DefaultLanguageLibrary defl,
     PARCEL.ReportType rt
WHERE  rt.ReportTypeID = defl.ReportTypeID AND
       defl.DefaultLanguageLibaryGuidBinary = @libraryGuidBinary;

END //
Delimiter ;