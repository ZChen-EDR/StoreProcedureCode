Delimiter //
DROP PROCEDURE IF EXISTS getLanguageLibraryListByCompany;
CREATE PROCEDURE `getLanguageLibraryListByCompany`(IN `ownerCompanyGuid` VARCHAR(32))
	COMMENT 'Retrieve all the Language Library for a particular company and the Libraries owned by other companies which this company has access to'
BEGIN

/* 

'Retrieve all the Language Library for a particular company and the Libraries owned by other companies but this company has access to'

*/

SET @ownerGuidBinary = PARCEL.guidToBinary(ownerCompanyGuid);


SELECT     defl.DefaultLanguageLibraryID as libraryID,
           PARCEL.binaryToGuid(defl.DefaultLanguageLibaryGuidBinary) as defaultLanguageLibraryGuid,
           defl.Name as name,
			  defl.OwnerCompanyID as ownerCompanyID,
			  PARCEL.binaryToGuid(defl.OwnerCompanyGuidBinary) as ownerCompanyGuidBinary,
			  defl.IsLibraryDisabled as isDeactivated,
			  defl.IsMobile as isMobile,
			  defl.LinkedLibraryID as linkedLibraryID,
			  defl.FromLibraryID as fromLibraryID
FROM       PARCEL.DefaultLanguageLibrary defl 
           LEFT JOIN
           PARCEL.CompanyLanguageLibrary cll ON cll.DefaultLanguageLibraryID = defl.DefaultLanguageLibraryID
WHERE      defl.IsLibraryDisabled = 0 AND
           (defl.OwnerCompanyGuidBinary = @ownerGuidBinary  OR 
			   cll.AccessCompanyGuidBinary = @ownerGuidBinary  OR 
				defl.OwnerCompanyID = 0);


END //
Delimiter ;