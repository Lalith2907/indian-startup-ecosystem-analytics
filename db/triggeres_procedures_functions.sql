-- Trigger 1: Prevent Deletion of Startups with Active Funding

DELIMITER / /

CREATE TRIGGER prevent_startup_delete
BEFORE DELETE ON startups
FOR EACH ROW
BEGIN
    DECLARE recent_funding_count INT;
    
    SELECT COUNT(*) INTO recent_funding_count
    FROM funding_rounds
    WHERE Startup_ID = OLD.Startup_ID
    AND Date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
    
    IF recent_funding_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete startup with recent funding rounds';
    END IF;
END//

DELIMITER;

-- Trigger 2: Prevents a startup from acquiring itself

DELIMITER / /

CREATE TRIGGER validate_acquisition
BEFORE INSERT ON acquisitions
FOR EACH ROW
BEGIN
    IF NEW.Acquirer_Startup_ID = NEW.Target_Startup_ID THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A startup cannot acquire itself';
    END IF;
END//

DELIMITER;

-- Procedure 1: Adds a new funding round and links multiple investors atomically

DELIMITER / /

CREATE PROCEDURE add_funding(
    IN p_round_id INT,
    IN p_startup_id INT,
    IN p_date DATE,
    IN p_amount DECIMAL(18,2),
    IN p_stage VARCHAR(50),
    IN p_investor_ids VARCHAR(255)
)
BEGIN
    DECLARE investor_id INT;
    DECLARE pos INT;
    DECLARE remaining VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error: Transaction rolled back' AS Message;
    END;
    
    START TRANSACTION;
    
    INSERT INTO funding_rounds (Round_ID, Startup_ID, Date, Amount, Stage)
    VALUES (p_round_id, p_startup_id, p_date, p_amount, p_stage);
    
    SET remaining = CONCAT(p_investor_ids, ',');
    
    WHILE LENGTH(remaining) > 0 DO
        SET pos = LOCATE(',', remaining);
        SET investor_id = CAST(SUBSTRING(remaining, 1, pos - 1) AS UNSIGNED);
        
        INSERT INTO funding_round_investors (Round_ID, Investor_ID)
        VALUES (p_round_id, investor_id);
        
        SET remaining = SUBSTRING(remaining, pos + 1);
    END WHILE;
    
    COMMIT;
    SELECT 'Funding round added successfully' AS Message;
END//

DELIMITER;

-- Procedure 2: Records an acquisition and updates both startups atomically

DELIMITER / /

CREATE PROCEDURE record_acq(
    IN p_acq_id INT,
    IN p_acquirer_id INT,
    IN p_target_id INT,
    IN p_date DATE,
    IN p_amount DECIMAL(18,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error: Acquisition transaction failed' AS Message;
    END;
    
    START TRANSACTION;
    
    INSERT INTO acquisitions (AcquisitionID, Acquirer_Startup_ID, Target_Startup_ID, Date, Amount)
    VALUES (p_acq_id, p_acquirer_id, p_target_id, p_date, p_amount);
    
    COMMIT;
    SELECT 'Acquisition recorded successfully' AS Message;
END//

DELIMITER;

-- Function 1: Calculate Total Funding for a Startup

DELIMITER / /

CREATE FUNCTION get_total_funding(p_startup_id INT)
RETURNS DECIMAL(18,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(18,2);
    
    SELECT IFNULL(SUM(Amount), 0) INTO total
    FROM funding_rounds
    WHERE Startup_ID = p_startup_id;
    
    RETURN total;
END//

DELIMITER;

-- Function 2: Returns the number of milestones achieved by a startup

DELIMITER / /

CREATE FUNCTION count_milestones(p_startup_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE milestone_count INT;
    
    SELECT COUNT(*) INTO milestone_count
    FROM startup_milestones
    WHERE Startup_ID = p_startup_id;
    
    RETURN milestone_count;
END//

DELIMITER;