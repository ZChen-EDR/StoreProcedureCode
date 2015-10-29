Delimiter //
DROP PROCEDURE IF EXISTS getReportOutputSetupListByType;
CREATE PROCEDURE `getReportOutputSetupListByType`(IN `ownerCompanyGuid` VARCHAR(32), 
                                                  IN `setupTypeValue` VARCHAR(256))

	COMMENT 'Retrieve the list of report output setup based on the company ID and report setup type'
BEGIN
         SET @ownerCompanyGuidBinary = PARCEL.guidToBinary(ownerCompanyGuid);
			/* Retrieve all the related attributes for a report output setup based on the companyID */
			
			SELECT ros.ReportOutputSetupID as reportOutputSetupID,
			       PARCEL.binaryToGuid(ros.ReportOutputSetupGuidBinary) as reportOutputSetupGuid,
			       ros.Name as name,
			  		 ros.ROSStyleSheetFilePath AS cssPath,
			  		 ros.ROSDocument AS jsonDataPath,
			  		 ros.OwnerCompanyID AS ownerCompanyID
			FROM PARCEL.ReportOutputSetup ros
			
			JOIN PARCEL.LocalCodeValue lcv ON ros.ReportSetupTypeCode = lcv.LocalCodeValueID
			JOIN PARCEL.LocalCodeTable lct ON lcv.LocalCodeTableID = lct.LocalCodeTableID
			WHERE (ros.OwnerCompanyGuidBinary = @ownerCompanyGuidBinary OR 
			       ros.OwnerCompanyID = 0) AND
			      ros.IsReportOutputSetupDisabled = 0 AND
					lcv.CodeValueShortName = setupTypeValue AND
			      lct.CodeTableName = 'ReportSetupType'; 

END //
Delimiter ;