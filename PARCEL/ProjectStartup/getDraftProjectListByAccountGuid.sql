Delimiter //
DROP PROCEDURE IF EXISTS getDraftProjectListByAccountGuid;
CREATE PROCEDURE getDraftProjectListByAccountGuid(IN accountGuid VARCHAR(32))
BEGIN
      SET @accountGuidBinary = PARCEL.guidToBinary(accountGuid);
      
		SELECT dp.DraftProjectDocument as draftProject,
		       PARCEL.binaryToGuid(dp.DraftProjectGuidBinary) as draftProjectGuid,
		       PARCEL.binaryToGuid(dp.CreatedAccountGuidBinary) as creatorAccountGuid,
		       dp.CreatedAccountID as creatorAccountID,
		       dp.CreatedTimestamp as creationTimestamp,
		       dp.ModifiedTimestamp as modifiedTimestamp
      FROM PARCEL.DraftProject dp
      WHERE dp.CreatedAccountGuidBinary = @accountGuidBinary;

END //
Delimiter ;