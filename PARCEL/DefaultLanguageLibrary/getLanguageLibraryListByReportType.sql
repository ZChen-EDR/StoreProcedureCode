Delimiter //
DROP PROCEDURE IF EXISTS getLanguageLibraryListByReportType;
CREATE PROCEDURE `getLanguageLibraryListByReportType`(IN `ownerCompanyGuid` VARCHAR(32),
                                                      IN `reportTypeID` BIGINT)
	COMMENT 'Retrieve all the Language Library for a particular company and the Libraries owned by other companies which this company has access to'
BEGIN

/* 

'Retrieve all the Language Library for a particular company and the Libraries owned by other companies but this company has access to'

*/

SET @ownerGuidBinary = PARCEL.guidToBinary(`ownerCompanyGuid`);


SELECT     defl.DefaultLanguageLibraryID as libraryID,
           PARCEL.binaryToGuid(defl.DefaultLanguageLibaryGuidBinary) as defaultLanguageLibraryGuid,
           defl.Name as name,
			  defl.OwnerCompanyID as ownerCompanyID,
			  PARCEL.binaryToGuid(defl.OwnerCompanyGuidBinary) as ownerCompanyGuidBinary,
			  defl.IsLibraryDisabled as isDeactivated,
			  defl.IsMobile as isMobile,
			  defl.LinkedLibraryID as linkedLibraryID,
			  defl.FromLibraryID as fromLibraryID,
			  rt.ReportTypeID as reportTypeID,
			  rt.Name as reportName,
			  rt.Value as reportValue

FROM       PARCEL.DefaultLanguageLibrary defl,
           PARCEL.ReportType rt 

WHERE      rt.ReportTypeID = defl.ReportTypeID AND
           defl.IsLibraryDisabled = 0 AND
           (defl.OwnerCompanyGuidBinary = @ownerGuidBinary  OR 
				defl.OwnerCompanyID = 0) AND
				defl.ReportTypeID = reportTypeID;


END //
Delimiter ;