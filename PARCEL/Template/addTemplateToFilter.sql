Delimiter //
DROP PROCEDURE IF EXISTS addTemplateToFilter;
CREATE PROCEDURE addTemplateToFilter(IN filterID BIGINT,
                                     IN accountID BIGINT,
                                     IN accountGUID VARCHAR(32),
                                     IN templateID BIGINT)
BEGIN 
      SET @accountGuidBinary = PARCEL.guidToBinary('accountGUID');
      INSERT INTO PARCEL.FilterTemplate (TemplateFilterID,
                                         TemplateID,
                                         CreatedAccountID,
                                         CreatedAccountGuidBinary)
                                         VALUES
                                         (filterID,
                                          templateID,
                                          accountID,
                                          @accountGuidBinary);
END //
Delimiter ;