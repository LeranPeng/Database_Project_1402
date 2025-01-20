CREATE TABLE PhoneModel (
  modelNumber TEXT PRIMARY KEY,
  modelName TEXT,
  storage INTEGER,
  colour TEXT,
  baseCost REAL,
  dailyCost REAL,
  UNIQUE (modelNumber, modelName)
);

CREATE TABLE Customer (
  customerId INTEGER PRIMARY KEY,
  customerName TEXT,
  customerEmail TEXT
);

CREATE TABLE Phone (
  modelNumber TEXT,
  modelName TEXT,
  IMEI TEXT PRIMARY KEY CHECK (
    (
        substr(IMEI,1,1) +
        substr(IMEI,3,1) +
        substr(IMEI,5,1) +
        substr(IMEI,7,1) +
        substr(IMEI,9,1) +
        substr(IMEI,11,1) +
        substr(IMEI,13,1) +
        substr(IMEI,15,1) +
        (substr(IMEI,2,1)*2 - 9*(substr(IMEI,2,1)*2 > 9)) +
        (substr(IMEI,4,1)*2 - 9*(substr(IMEI,4,1)*2 > 9)) +
        (substr(IMEI,6,1)*2 - 9*(substr(IMEI,6,1)*2 > 9)) +
        (substr(IMEI,8,1)*2 - 9*(substr(IMEI,8,1)*2 > 9)) +
        (substr(IMEI,10,1)*2 - 9*(substr(IMEI,10,1)*2 > 9)) +
        (substr(IMEI,12,1)*2 - 9*(substr(IMEI,12,1)*2 > 9)) +
        (substr(IMEI,14,1)*2 - 9*(substr(IMEI,14,1)*2 > 9))
  ) % 10 = 0),
  FOREIGN KEY (modelNumber,modelName) REFERENCES PhoneModel(modelNumber,modelName)
);

CREATE TABLE rentalContract (
    customerId INTEGER,
    IMEI  TEXT,
    dateOut TEXT,
    dateBack TEXT,
    rentalCost REAL,
    PRIMARY KEY(customerId, IMEI,dateOut),
    FOREIGN KEY (customerId) REFERENCES Customer(customerId),
    FOREIGN KEY (IMEI) REFERENCES Phone(IMEI) ON DELETE SET NULL
);