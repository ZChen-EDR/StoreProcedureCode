Delimiter //
DROP PROCEDURE IF EXISTS getReportOutputSetupListByCompany;
CREATE  PROCEDURE `getReportOutputSetupListByCompany`(IN `companyGuid` VARCHAR(32))
	
	COMMENT 'Retrieve all the report output setup by only company ID'
BEGIN
   
   SET @ownerCompanyGuid = PARCEL.guidToBinary(companyGuid);
   /*transmittal setup*/
   SELECT ros.ReportOutputSetupID as reportOutputSetupID,
          PARCEL.binaryToGuid(ros.ReportOutputSetupGuidBinary) as reportOutputSetupGuid,
	       ros.Name as name,
	  		 ros.ROSStyleSheetFilePath as cssPath,
	  		 ros.ROSDocument as jsonDataPath,
	  		 lcv.CodeValueName as ReportSetupType,
	  		 lcv.CodeValueShortName as setupTypeValue,
	  		 ros.OwnerCompanyID as ownerCompanyID
	FROM PARCEL.ReportOutputSetup ros
	
	/* The JOIN has to be done to get the report setup type value */
	
	JOIN PARCEL.LocalCodeValue lcv ON ros.ReportSetupTypeCode = lcv.LocalCodeValueID
	JOIN PARCEL.LocalCodeTable lct ON lcv.LocalCodeTableID = lct.LocalCodeTableID
	WHERE (ros.OwnerCompanyGuidBinary = @ownerCompanyGuid OR 
	      ros.OwnerCompanyID = 0) AND
	      ros.IsReportOutputSetupDisabled = 0 AND
			lcv.CodeValueShortName =  'TRANS_SET' AND
	      lct.CodeTableName = 'ReportSetupType'; 
	      
	/*toc setup*/
	SELECT ros.ReportOutputSetupID as reportOutputSetupID,
	       PARCEL.binaryToGuid(ros.ReportOutputSetupGuidBinary) as reportOutputSetupGuid,
	       ros.Name as name,
	  		 ros.ROSStyleSheetFilePath as cssPath,
	  		 ros.ROSDocument as jsonDataPath,
	  		 lcv.CodeValueName as ReportSetupType,
	  		 lcv.CodeValueShortName as SetupTypeShortName
	FROM PARCEL.ReportOutputSetup ros
	
	/* The JOIN has to be done to get the report setup type value */
	
	JOIN PARCEL.LocalCodeValue lcv ON ros.ReportSetupTypeCode = lcv.LocalCodeValueID
	JOIN PARCEL.LocalCodeTable lct ON lcv.LocalCodeTableID = lct.LocalCodeTableID
	WHERE (  ros.OwnerCompanyGuidBinary = @ownerCompanyGuid OR 
		      ros.OwnerCompanyID = 0) AND
		      ros.IsReportOutputSetupDisabled = 0 AND
				lcv.CodeValueShortName =  'TOC_SET' AND
		      lct.CodeTableName = 'ReportSetupType'; 
	      
	
	/*report output setup*/
	SELECT ros.ReportOutputSetupID as reportOutputSetupID,
	       PARCEL.binaryToGuid(ros.ReportOutputSetupGuidBinary) as reportOutputSetupGuid,
	       ros.Name as name,
	  		 ros.ROSStyleSheetFilePath as cssPath,
	  		 ros.ROSDocument as jsonDataPath,
	  		 lcv.CodeValueName as ReportSetupType,
	  		 lcv.CodeValueShortName as SetupTypeShortName
	FROM PARCEL.ReportOutputSetup ros
	
	/* The JOIN has to be done to get the report setup type value */
	
	JOIN PARCEL.LocalCodeValue lcv ON ros.ReportSetupTypeCode = lcv.LocalCodeValueID
	JOIN PARCEL.LocalCodeTable lct ON lcv.LocalCodeTableID = lct.LocalCodeTableID
	WHERE (ros.OwnerCompanyGuidBinary = @ownerCompanyGuid OR 
	      ros.OwnerCompanyID = 0) AND
	      ros.IsReportOutputSetupDisabled = 0 AND
			lcv.CodeValueShortName =  'ROS_SET' AND
	      lct.CodeTableName = 'ReportSetupType'; 


END //
Delimiter ;