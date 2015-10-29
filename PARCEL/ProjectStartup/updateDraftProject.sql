Delimiter //
DROP PROCEDURE IF EXISTS updateDraftProject ;
CREATE PROCEDURE updateDraftProject(IN `accountID` BIGINT, 
                                    IN `draftProjectDocument` LONGTEXT, 
												IN `draftProjectGuid` VARCHAR(32), 
												IN `accountGuid` VARCHAR(32))
BEGIN
      /*conver to binary*/
     SET @draftProjectGuidBinary = PARCEL.guidToBinary(draftProjectGuid);
     SET @accountGuidBinary = PARCEL.guidToBinary(draftProjectGuid);
     
     /*input data*/
     UPDATE PARCEL.DraftProject dp
     SET dp.DraftProjectDocument = draftProjectDocument,
         dp.ModifiedAccountID = accountID,
         dp.ModifiedTimestamp = CURRENT_TIME(),
         dp.ModifiedAccountGuidBinary = @accountGuidBinary
     WHERE dp.DraftProjectGUIDBinary = @draftProjectGuidBinary;
                                    
                                       
END //
Delimiter;
                                      