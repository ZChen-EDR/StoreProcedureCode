Delimiter //
DROP PROCEDURE IF EXISTS deleteReportOutputSetup;
CREATE  PROCEDURE `deleteReportOutputSetup`(IN `reportOutputSetupGuid` VARCHAR(32),
                                            IN `accountID` BIGINT,
                                            IN `accountGuid` VARCHAR(32))
	COMMENT 'Delete an existing Report Output Setup'
BEGIN

SET @reportOutputSetupGuidBinary = PARCEL.guidToBinary(reportOutputSetupGuid);

UPDATE PARCEL.ReportOutputSetup ros

		SET ros.IsReportOutputSetupDisabled = 1,
		    ros.StandardizedROSName = NULL,
		    ros.DeletedAccountID = accountID,
		    ros.DeletedTimestamp = CURRENT_TIMESTAMP
		WHERE ros.ReportOutputSetupGuidBinary = @reportOutputSetupGuidBinary;
		

END //
Delimiter ;