USE TestGrinHouse;

-- Ensure Greenhouse table exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Greenhouse]') AND type = N'U')
BEGIN
    CREATE TABLE dbo.Greenhouse (
        greenhouseId INT PRIMARY KEY NOT NULL,
        greenhouseName NVARCHAR(100) NOT NULL,
        loginName NVARCHAR(100) NOT NULL,
        loginPassword NVARCHAR(100) NOT NULL
    );
END;

-- Ensure HumidifierState table exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HumidifierState]') AND type = N'U')
BEGIN
    CREATE TABLE dbo.HumidifierState (
        humidifierId INT IDENTITY PRIMARY KEY NOT NULL,
        isHumidifierOn BIT NOT NULL,
        isDeHumidifierOn BIT NOT NULL,
        stateDateTime DATETIME NOT NULL,
        greenhouseId INT NOT NULL,
        CONSTRAINT FK_HumidifierState_Greenhouse FOREIGN KEY (greenhouseId) REFERENCES dbo.Greenhouse(greenhouseId)
    );
END;

-- Ensure ACState table exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ACState]') AND type = N'U')
BEGIN
    CREATE TABLE dbo.ACState (
        acStateId INT IDENTITY PRIMARY KEY NOT NULL,
        isHeaterOn BIT NOT NULL,
        isCoolerOn BIT NOT NULL,
        stateDateTime DATETIME NOT NULL,
        greenhouseId INT NOT NULL,
        CONSTRAINT FK_ACState_Greenhouse FOREIGN KEY (greenhouseId) REFERENCES dbo.Greenhouse(greenhouseId)
    );
END;

-- Ensure CarbonDioxideGeneratorState table exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CarbonDioxideGeneratorState]') AND type = N'U')
BEGIN
    CREATE TABLE dbo.CarbonDioxideGeneratorState (
        carbonDioxideGeneratorId INT IDENTITY PRIMARY KEY NOT NULL,
        isCarbonDioxideGeneratorOn BIT NOT NULL,
        stateDateTime DATETIME NOT NULL,
        greenhouseId INT NOT NULL,
        CONSTRAINT FK_CarbonDioxideGeneratorState_Greenhouse FOREIGN KEY (greenhouseId) REFERENCES dbo.Greenhouse(greenhouseId)
    );
END;

-- Ensure ThresholdProfile table exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ThresholdProfile]') AND type = N'U')
BEGIN
    CREATE TABLE dbo.ThresholdProfile (
        thresholdProfileId INT IDENTITY PRIMARY KEY NOT NULL,
        profileName NVARCHAR(100) NOT NULL,
        active BIT NOT NULL,
        minimumTemperature FLOAT NOT NULL,
        maximumTemperature FLOAT NOT NULL,
        minimumHumidity FLOAT NOT NULL,
        maximumHumidity FLOAT NOT NULL,
        minimumCarbonDioxide FLOAT NOT NULL,
        maximumCarbonDioxide FLOAT NOT NULL,
        greenhouseId INT NOT NULL,
        CONSTRAINT FK_ThresholdProfile_Greenhouse FOREIGN KEY (greenhouseId) REFERENCES dbo.Greenhouse(greenhouseId)
    );
END;

-- Ensure MeasurementType table exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MeasurementType]') AND type = N'U')
BEGIN
    CREATE TABLE dbo.MeasurementType (
        title NVARCHAR(20) PRIMARY KEY NOT NULL CHECK (title IN ('temperature', 'humidity', 'carbonDioxide'))
    );
END;

-- Ensure Measurement table exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Measurement]') AND type = N'U')
BEGIN
    CREATE TABLE dbo.Measurement (
        measurementId INT IDENTITY PRIMARY KEY NOT NULL,
        measuredValue FLOAT NOT NULL,
        measurementDateTime DATETIME NOT NULL,
        greenhouseId INT NOT NULL,
        measurementType NVARCHAR(20) NOT NULL,
        CONSTRAINT FK_Measurement_Greenhouse FOREIGN KEY (greenhouseId) REFERENCES dbo.Greenhouse(greenhouseId),
        CONSTRAINT FK_Measurement_Type FOREIGN KEY (measurementType) REFERENCES dbo.MeasurementType(title)
    );
END;

-- Insert default values into MeasurementType
IF NOT EXISTS (SELECT * FROM dbo.MeasurementType WHERE title = 'temperature')
    INSERT INTO dbo.MeasurementType (title) VALUES ('temperature');

IF NOT EXISTS (SELECT * FROM dbo.MeasurementType WHERE title = 'humidity')
    INSERT INTO dbo.MeasurementType (title) VALUES ('humidity');

IF NOT EXISTS (SELECT * FROM dbo.MeasurementType WHERE title = 'carbonDioxide')
    INSERT INTO dbo.MeasurementType (title) VALUES ('carbonDioxide');
