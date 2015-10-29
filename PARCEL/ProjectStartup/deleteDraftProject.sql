Delimiter //
DROP PROCEDURE IF EXISTS deleteDraftProject;
CREATE PROCEDURE deleteDraftProject(IN accountID BIGINT,
                                    IN accountGuid VARCHAR(32),
												IN draftProjectGuid VARCHAR(32),
												IN actionPerformed ENUM('Delete','Complete'))
BEGIN

     
     DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	  BEGIN
			   GET DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
			   SELECT @p1,@p2;
			   
			   ROLLBACK;
		  
	  END;
	  
	  START TRANSACTION;
      
     
   
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
	  WHERE DraftProjectGuidBinary = @draftProjectGuidBinary;
                                    
     COMMIT;                                      
END //
Delimiter;
                 