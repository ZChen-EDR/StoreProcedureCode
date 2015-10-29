Delimiter //
DROP PROCEDURE IF EXISTS getReportOutputSetupDetail;
CREATE  PROCEDURE `getReportOutputSetupDetail`(IN `reportOutputSetupGuid` VARCHAR(32))
	COMMENT 'Retrieve report output setup details'
BEGIN

/* Retrieve all the related attributes for a report output setup based on the reportOutputSetupID */

SET @reportOutputGuidBinary = PARCEL.guidToBinary(reportOutputSetupGuid);
SELECT 
    ros.ReportOutputSetupID AS reportOutputSetupID,
    ros.Name AS name,
    ros.ROSStyleSheetFilePath AS cssPath,
    ros.ROSDocument AS jsonPath,
    lcv.CodeValueName AS setupType
    
FROM PARCEL.ReportOutputSetup ros
JOIN PARCEL.LocalCodeValue lcv ON ros.ReportSetupTypeCode = lcv.LocalCodeValueID
WHERE ros.ReportOutputSetupGuidBinary = @reportOutputGuidBinary;

END //
Delimiter ;