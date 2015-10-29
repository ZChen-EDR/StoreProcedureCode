Delimiter //
DROP PROCEDURE IF EXISTS getAllSectionForTemplate;
CREATE PROCEDURE getAllSectionForTemplate(IN templateGuid VARCHAR(32))
BEGIN
      SET @templateGuidBinary = PARCEL.guidToBinary(templateGuid);
      SELECT t.TemplateID AS templateID,
             PARCEL.binaryToGuid(t.TemplateGuidBinary) AS templateGuid,
             ts.SectionID AS sectionID,
             PARCEL.binaryToGuid(s.SectionGuidBinary) AS sectionGuidBinary,
             ts.SectionStructure AS sectionHTML
      FROM PARCEL.Template t,
           PARCEL.TemplateSection ts,
           PARCEL.Section s
      WHERE t.TemplateID = ts.TemplateID AND 
            s.SectionID = ts.SectionID AND
            t.TemplateGuidBinary = @templateGuidBinary;
END //
Delimiter ;