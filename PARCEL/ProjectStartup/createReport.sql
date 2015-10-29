Delimiter //
DROP PROCEDURE IF EXISTS createReport;
CREATE  PROCEDURE `createReport`(IN `property_id` INT, IN `templateID` INT, IN `libraryID` INT, IN `taskedCompanyID` INT, IN `projectNumber` VARCHAR(256), IN `fee` VARCHAR(256), IN `poNumber` VARCHAR(256), IN `outToBid` INT, IN `reportGuid` VARCHAR(32), OUT `reportID` INT)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN
   DECLARE report_status_id INT;
   
   /*setup attributes for report*/
   DECLARE report_output_setup_id INT;
   DECLARE company_cover_template_id INT;
   DECLARE transmittal_setup_id INT;
   DECLARE table_of_content_setup_id INT;
   DECLARE template_doc LONGTEXT;
   DECLARE reportGuidBinary BINARY(16);
   
   
   /*get default setting for a template
   SELECT dtc.ReportOutputSetupID,
	       dtc.CompanyCoverTemplateID,
			 dtc.TransmittalSetupID,
			 dtc.TableOfContentSetupID
   INTO report_output_setup_id, 
	     company_cover_template_id,
		  transmittal_setup_id,
		  table_of_content_setup_id
   FROM PARCEL.DefaultTemplateConfig dtc
	WHERE dtc.TemplateID = templateID;*/
	
	/*get the template document
	SELECT t.TemplateDocument
	INTO template_doc
	FROM PARCEL.Template t
	WHERE t.TemplateID = templateID;*/
   
   
   
   /*select the lowest level of the status*/
	SELECT rs.ReportStatusID
	INTO report_status_id
	FROM PARCEL.ReportStatus rs,
		 	  PARCEL.LocalCodeTable lct,
			  PARCEL.LocalCodeValue lcv
	WHERE rs.ReportStatusCode = lcv.LocalCodeValueID AND
				lct.LocalCodeTableID = lcv.LocalCodeTableID AND
		      lct.CodeTableName = 'ReportStatus' AND
		      rs.Rank = (SELECT min(rs2.Rank)
		                 FROM PARCEL.ReportStatus rs2);
	
	
	
	/*punch in the data*/
	SET reportGuidBinary = PARCEL.guidToBinary(reportGuid);
	INSERT INTO PARCEL.Report (PropertyID,TemplateID,DefaultLanguageLibraryID,TaskedCompanyID,
	                             ProjectNumber,Fee,PoNumber,ReportStatusID,
										  CompanyCoverTemplateID,OutToBid,ReportGUIDBinary) VALUES
	      
	      (property_id,templateID,libraryID,taskedCompanyID,projectNumber,fee,poNumber,reportStatusID,
	       company_cover_template_id,outToBid,reportGuidBinary);
	      
	SELECT last_insert_id() into reportID;
   /*copy the template default setup to report default setup*/
   CALL PARCEL.copyTemplateSetupToReport(templateID, reportID);

END //
Delimiter ;