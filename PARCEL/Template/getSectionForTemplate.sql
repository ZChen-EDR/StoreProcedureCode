Delimiter //
DROP PROCEDURE IF EXISTS getSectioNForTemplate;
CREATE PROCEDURE getSectionForTemplate(IN templateGuid VARCHAR(32),
                                       IN sectionGuid VARCHAR(32))   
BEGIN
     
	  SET @templateGuidBinary = PARCEL.guidToBinary(templateGuid); 
     SET @sectionGuidBinary = PARCEL.guidToBinary(sectionGuid); 
     
     SELECT ts.TemplateSectionID as templateSectionID,
            ts.SectionStructure as sectionHtml
	  FROM PARCEL.Template pt,
	       PARCEL.TemplateSection ts,
			 PARCEL.Section ps
	  WHERE pt.TemplateID = ts.TemplateID AND
	        ps.SectionID = ts.SectionID AND
			  pt.TemplateGuidBinary = @templateGuidBinary AND
			  ps.SectionGuidBinary = @sectionGuidBinary;
END //
Delimiter ;										                     