Delimiter //
DROP PROCEDURE IF EXISTS createDraftProject ;
CREATE PROCEDURE createDraftProject(IN companyID BIGINT,
                                    IN accountID BIGINT,
												IN draftProjectDocument LONGTEXT)
BEGIN
     INSERT INTO PARCEL.DraftProject (DraftProjectDocument,
                                      CreatedAccountID,
                                      OwnerCompanyID)
                                      VALUES
                                      (draftProjectDocument,
                                       accountID,
                                       companyID);
                                       
     SELECT last_insert_id() INTO @draftProjectID;
END //
Delimiter ;
                                      