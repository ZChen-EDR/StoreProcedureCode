Delimiter //
DROP PROCEDURE IF EXISTS removeTemplateFromFilter;
CREATE PROCEDURE removeTemplateFromFilter(IN filterID BIGINT,
                                          IN templateID BIGINT)
BEGIN
       
       DELETE 
       FROM PARCEL.FilterTemplate 
       WHERE PARCEL.FilterTemplate.TemplateFilterID = filterID AND
             PARCEL.FilterTemplate.TemplateID = templateID;
      
END //
Delimiter ;