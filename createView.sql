CREATE VIEW CustomerSummary AS
    SELECT 
        rentalContract.customerId,
        COALESCE(PhoneModel.modelName, NULL) AS modelName,
        SUM(
            CASE
                WHEN rentalContract.dateBack IS NOT NULL
                THEN julianday(rentalContract.dateBack) - julianday(rentalContract.dateOut) + 1
                ELSE 0
            END
        ) AS daysRented,
        CASE
            WHEN CAST(strftime('%m', dateBack) AS INTEGER) BETWEEN 7 AND 12
            THEN (strftime('%Y', dateBack)) || '/' || substr((strftime('%Y', dateBack, '+1 year')), 3, 2)
            ELSE (CAST(strftime('%Y', dateBack) AS INTEGER) - 1) || '/' || substr((strftime('%Y', dateBack)), 3, 2)
        END AS taxYear,
        SUM(rentalContract.rentalCost) AS rentalCost
    FROM rentalContract
    LEFT JOIN Phone USING (IMEI)
    LEFT JOIN PhoneModel USING (modelNumber, modelName)
    WHERE rentalContract.dateBack IS NOT NULL
    AND (julianday(rentalContract.dateBack) - julianday(rentalContract.dateOut)) >= 0
    GROUP BY rentalContract.customerId, taxYear, COALESCE(PhoneModel.modelName, NULL)