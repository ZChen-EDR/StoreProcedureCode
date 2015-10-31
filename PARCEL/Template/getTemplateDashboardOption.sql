Delimiter //
DROP PROCEDURE IF EXISTS getTemplateDashboardOption;
CREATE  PROCEDURE `getTemplateDashboardOption`()
	COMMENT 'This procedure retrieves all the Dashboard options for a template'
BEGIN

SELECT lcv.LocalCodeValueID as dashboardOptionTypeID,
       lcv.CodeValueShortName as dashboardOptionShortName,
       lcv.CodeValueName as dashboardOptionName

FROM  PARCEL.LocalCodeTable lct
JOIN  PARCEL.LocalCodeValue lcv ON lcv.LocalCodeTableID = lct.LocalCodeTableID
-- JOIN  PARCEL.LocalCodeTable lct ON lct.LocalCodeTableID = lcv.LocalCodeTableID

WHERE lct.CodeTableName = 'DashboardOptionType'; 

END //
Delimiter ;