Delimiter //
DROP PROCEDURE IF EXISTS assignDefaultVendorTemplate;
CREATE PROCEDURE assignDefaultVendorTemplate(IN consultantGuid VARCHAR(32),
                                             IN consultantCompanyID BIGINT,
                                             IN clientGuid VARCHAR(32),
                                             IN clientCompanyID BIGINT,
                                             IN templateGuid VARCHAR(32))
BEGIN
     SET @conGuidBinary = PARCEL.guidToBinary(consultantGuid);
     SET @cliGuidBinary = PARCEL.guidToBinary(clientGuid);
     SET @templateID = PARCEL.getTemplateIDByGuid(templateGuid);
     
     
     INSERT INTO PARCEL.DefaultLenderTemplate(  `ClientCompanyID`,
																`ClientCompanyGuidBinary`,
																`ConsultantCompanyID`,
																`ConsultantCompanyGuidBinary`,
																`TemplateID`)
												VALUES   (clientCompanyID,
												          @cliGuidBinary,
												          consultantCompanyID,
												          @conGuidBinary,
												          @templateID);

END //
Delimiter ;
     
     