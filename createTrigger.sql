CREATE TRIGGER UpdateRentalCost
AFTER UPDATE ON rentalContract
FOR EACH ROW
WHEN NEW.dateBack IS NOT NULL AND OLD.dateBack IS NULL
BEGIN
    UPDATE rentalContract
    SET rentalCost = (
        SELECT ROUND((baseCost + dailyCost * (1 + julianday(NEW.dateBack) - julianday(NEW.dateOut))),2)
        FROM Phone
        JOIN PhoneModel USING (modelNumber, modelName)
        WHERE Phone.IMEI = NEW.IMEI
    )
    WHERE customerId = NEW.customerId AND IMEI = NEW.IMEI AND rentalcost IS NULL;
END;