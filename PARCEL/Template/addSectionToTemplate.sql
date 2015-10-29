Delimiter //
DROP PROCEDURE IF EXISTS PARCEL.addSectionToTemplate;
CREATE PROCEDURE addSectionToTemplate(IN sectionGuid VARCHAR(32),
                                      IN templateGuid VARCHAR(32),
												  IN sectionHtml LONGTEXT)
Comment 'Template customization and note ALL reports that are created based on this template will be affected'
BEGIN
    
     SET @sectionGuidBinary = PARCEL.guidToBinary(sectionGuid);
     SET @templateGuidBinary = PARCEL.guidToBinary(templateGuid);
     
     SELECT t.TemplateID INTO @templateID
     FROM PARCEL.Template t
     WHERE t.TemplateGuidBinary = @templateGuidBinary;
     
     SELECT s.SectionID INTO @sectionID
     FROM PARCEL.Section s
     WHERE s.SectionGuidBinary = @sectionGuidBinary;
     
     
     
	  INSERT INTO PARCEL.TemplateSection(SectionID, 
	                                     TemplateID, 
													 SectionStructure)
									     VALUES
										         (@sectionID,
													 @templateID,
													 sectionHtml);
END //
Delimiter ;                       