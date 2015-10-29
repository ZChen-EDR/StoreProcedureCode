Delimiter //
DROP PROCEDURE IF EXISTS createTemplateFilter;
CREATE PROCEDURE createTemplateFilter(IN templateFilterName VARCHAR(256),
                                      IN accountGuid VARCHAR(32),
                                      IN ownerCompanyGuid VARCHAR(32),
                                      IN accountID BIGINT,
                                      IN ownerCompanyID BIGINT,
												  OUT templateFilterID BIGINT)
BEGIN
      
	      SET @accountGuidBinary = PARCEL.guidToBinary(accountGuid);
	      SET @ownerCompanyGuid = PARCEL.guidToBinary(ownerCompanyGuid);
	      SET @standardizedName = TRIM(UPPER(templateFilterName));
	      
	      INSERT INTO PARCEL.TemplateFilter (Name, 
			                                   OwnerCompanyGuidBinary, 
														  OwnerCompanyID, 
														  CreatedAccountID, 
														  CreatedAccountGuidBinary,
														  StandardizedName) 
														  VALUES
														  (templateFilterName,
														   @ownerCompanyGuid,
														   ownerCompanyID,
														   accountID,
														   @accountGuidBinary,
														   @standardizedName);
														   
	       						
      
        SELECT LAST_INSERT_ID() INTO templateFilterID;
      
		
END //
Delimiter ;