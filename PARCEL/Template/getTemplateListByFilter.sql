Delimiter //
DROP PROCEDURE IF EXISTS getTemplateListByFilter;
CREATE PROCEDURE getTemplateListByFilter(IN filterID BIGINT)
BEGIN
      SELECT pt.TemplateID as templateID,
             PARCEL.binaryToGuid(pt.TemplateGuidBinary) as templateGuid,
             pt.Name as templateName,
             pt.ReportTypeID as reportTypeID,
             rt.Name as reportName,
             rt.Value as reportValue
      FROM PARCEL.Template pt,
           PARCEL.ReportType rt,
           PARCEL.TemplateFilter ptf,
           PARCEL.FilterTemplate pft
      WHERE pt.TemplateID = pft.TemplateID AND
            ptf.TemplateFilterID = pft.TemplateFilterID AND
				pt.ReportTypeID = rt.reportTypeID AND
				pt.IsTemplateDisabled = 0 AND
				ptf.TemplateFilterID = filterID;
END //
Delimiter;