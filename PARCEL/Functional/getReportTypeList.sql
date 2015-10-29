Delimiter //
DROP PROCEDURE IF EXISTS getReportTypeList;
CREATE PROCEDURE getReportTypeList()
BEGIN 
      SELECT rt.ReportTypeID as reportTypeID,
             rt.Name as reportTypeName,
             rt.Value as reportTypeValue
      FROM PARCEL.ReportType rt;

END //
Delimiter ;