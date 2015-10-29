Delimiter //
DROP PROCEDURE IF EXISTS getDraftProjectByID;
CREATE PROCEDURE getDraftProjectByID(IN draftProjectGuid VARCHAR(32))
BEGIN
      SET @draftProjectGuidBinary = PARCEL.guidToBinary(draftProjectGuid);
      
      SELECT dp.DraftProjectGUIDBinary as draftProjectGuid,
             dp.DraftProjectDocument as `draftProject`
      FROM PARCEL.DraftProject dp
      WHERE dp.DraftProjectGuidBinary = @draftProjectGuidBinary;
END //
Delimiter ;
      