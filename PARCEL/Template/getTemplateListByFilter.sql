Delimiter //
DROP PROCEDURE IF EXISTS getTemplateListByFilter;
CREATE PROCEDURE getTemplateListByFilter(IN filterID BIGINT,
                                         IN `reportTypeID` BIGINT)
BEGIN
      SELECT pt.TemplateID as templateID,
             pt.Name as templateName
      FROM PARCEL.Template pt,
           PARCEL.TemplateFilter ptf,
           PARCEL.FilterTemplate pft
      WHERE pt.TemplateID = pft.TemplateID AND
            pft.TemplateFilterID = ptf.TemplateFilterID AND
				pt.ReportTypeID = reportTypeID AND
				pt.IsTemplateDisabled = 0;
END //
Delimiter;