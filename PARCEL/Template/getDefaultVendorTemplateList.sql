Delimiter //
DROP PROCEDURE IF EXISTS getDefaultVendorTemplateList;
CREATE PROCEDURE getDefaultVendorTemplateList(IN consultantGuid VARCHAR(32))
BEGIN
      SET @conCompanyBinary = PARCEL.guidToBinary(consultantGuid);
      
      SELECT PARCEL.binaryToGuid(dlt.ClientCompanyGuidBinary) as clientCompanyGuid,
             dlt.ClientCompanyID as clientCompanyID,
             pt.TemplateID as templateID,
             PARCEL.binaryToGuid(pt.TemplateGuidBinary) as templateGuid,
             pt.Name as templateName,
             prt.ReportTypeID as reportTypeID,
             prt.Name as reportTypeName,
             prt.Value as reportTypeValue
      FROM PARCEL.DefaultLenderTemplate dlt,
           PARCEL.Template pt,
           PARCEL.ReportType prt
      WHERE  pt.TemplateID = dlt.TemplateID AND
             pt.ReportTypeID = prt.ReportTypeID AND
		       dlt.ConsultantCompanyGuidBinary = @conCompanyBinary;
END //
Delimiter ;