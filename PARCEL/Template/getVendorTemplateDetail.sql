Delimiter //
DROP PROCEDURE IF EXISTS getVendorTemplateDetail;
CREATE  PROCEDURE `getVendorTemplateDetail`(IN `consultantCompanyGuid` VARCHAR(32), 
                                            IN `clientCompanyGuid` VARCHAR(32), 
														  IN `templateReportTypeValue` VARCHAR(256))
	COMMENT 'This procedure will return the specific template a Vendor had setup to use when tasked by a Lender for a reportType'
BEGIN

		SET @conCompanyGuidBinary = PARCEL.guidToBinary(consultantCompanyGuid);
		SET @cliCompanyGuidBinary = PARCEL.guidToBinary(clientCompanyGuid);
		SELECT t.TemplateID  AS templateID,
				 rt.Value AS 'reportType',
				 t.Name AS name,
				 t.OwnerCompanyID AS ownerCompanyID,
				 t.ShortName AS shortName,
				 t.Description AS description,
				 t.IsMobile AS isMobile
		FROM  PARCEL.Template t,
		      PARCEL.ReportType rt, 
		      PARCEL.DefaultLenderTemplate dlt 
		WHERE t.ReportTypeID = rt.ReportTypeID AND 
		      t.TemplateID = dlt.TemplateID AND
		      dlt.ConsultantCompanyGuidBinary = @conCompanyGuidBinary AND
		      dlt.ClientCompanyGuidBinary = @cliCompanyGuidBinary AND
		      rt.Value =  templateReportTypeValue;

END //
Delimiter;