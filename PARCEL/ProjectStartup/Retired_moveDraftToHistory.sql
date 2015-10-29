Delimiter //
DROP PROCEDURE IF EXISTS moveDraftToHistory ;
CREATE PROCEDURE moveDraftToHistory(IN accountID BIGINT,
                                    IN accountGuid VARCHAR(32),
												IN draftProjectGuid VARCHAR(32),
												IN actionPerformed ENUM('Delete','Complete'))
BEGIN
     SET @actionPerformed = actionPerformed;
     SET @accountID = accountID;
     SET @createdAccountGuidBinary = PARCEL.guidToBinary(accountGuid);
     SET @draftProjectGuidBinary = PARCEL.guidToBinary(draftProjectGuid);
     
	  
	  INSERT INTO PARCEL.DraftProjectHistory (DraftProjectDocument, 
	                                          ActionPerformed,
															DraftCreatedAccountID, 
															CreatedAccountID,
															CreatedAccountGUIDBinary,
															DraftProjectGuidBinary)
	  SELECT dp.DraftProjectDocument,
	         @actionPerformed, 
				dp.CreatedAccountID, 
				@accountID,
				@createdAccountGuidBinary,
				dp.DraftProjectGUIDBinary
	  FROM PARCEL.DraftProject dp
	  WHERE dp.DraftProjectGuidBinary = @draftProjectGuidBinary;
     
	  
	  DELETE
	  FROM PARCEL.DraftProject
	  WHERE dp.DraftProjectGUIDBinary = @draftProjectGuidBinary;
                                    
                                       
END //
Delimiter;
                 