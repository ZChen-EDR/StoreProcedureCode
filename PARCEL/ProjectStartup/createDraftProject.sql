Delimiter //
DROP PROCEDURE IF EXISTS createDraftProject ;
CREATE PROCEDURE createDraftProject(IN `companyID` BIGINT, 
                                    IN `accountID` BIGINT, 
												IN `draftProjectDocument` LONGTEXT, 
												IN `companyGuid` VARCHAR(32), 
												IN `accountGuid` VARCHAR(32), 
												IN `draftProjectGuid` VARCHAR(32),
												OUT `draftProjectID` INT)
BEGIN

     /*conver to binary*/
     SET @draftProjectGuidBinary = PARCEL.guidToBinary(draftProjectGuid);
     SET @createdAccountGuidBinary = PARCEL.guidToBinary(accountGuid);
     SET @ownerCompanyGuidBinary = PARCEL.guidToBinary(companyGuid);
     
     /*insert data*/
     INSERT INTO PARCEL.DraftProject (DraftProjectDocument,
                                      CreatedAccountID,
                                      OwnerCompanyID,
												  CreatedAccountGuidBinary,
												  OwnerCompanyGuidBinary,
												  DraftProjectGuidBinary)
                                      VALUES
                                      (draftProjectDocument,
                                       accountID,
                                       companyID,
                                       @createdAccountGuidBinary,
                                       @ownerCompanyGuidBinary,
													@draftProjectGuidBinary);
                                       
     SELECT last_insert_id() INTO @draftProjectID;
END //
Delimiter ;
                                      