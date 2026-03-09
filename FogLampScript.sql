-- Using statements

-- Creating the Database

-- creating the tables 
CREATE TABLE Workers (
    WorkerID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeNumber NVARCHAR(50) NOT NULL UNIQUE,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    ExperienceLevel INT NOT NULL DEFAULT 1,
    EfficiencyRating DECIMAL(5,2) NOT NULL DEFAULT 1.00,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE Workstations (
    WorkstationID INT IDENTITY(1,1) PRIMARY KEY,
    StationName NVARCHAR(100) NOT NULL,
    StationNumber INT NOT NULL UNIQUE,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    OrderNumber NVARCHAR(50) NOT NULL UNIQUE,
    LampType NVARCHAR(100) NOT NULL,
    TargetQuantity INT NOT NULL,
    CompletedQuantity INT NOT NULL DEFAULT 0,
    FailedQuantity INT NOT NULL DEFAULT 0,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Pending',
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE Bins (
    BinID INT IDENTITY(1,1) PRIMARY KEY,
    WorkstationID INT NOT NULL,
    BinName NVARCHAR(100) NOT NULL,
    CurrentLevel INT NOT NULL,
    MaxLevel INT NOT NULL,
    LowThreshold INT NOT NULL,
    Status NVARCHAR(50) NOT NULL DEFAULT 'OK',
    CONSTRAINT FK_Bins_Workstations
        FOREIGN KEY (WorkstationID) REFERENCES Workstations(WorkstationID)
);

CREATE TABLE WorkstationAssignments (
    AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
    WorkstationID INT NOT NULL,
    WorkerID INT NOT NULL,
    OrderID INT NULL,
    StartTime DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    EndTime DATETIME2 NULL,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Working',
    CONSTRAINT FK_Assignments_Workstations
        FOREIGN KEY (WorkstationID) REFERENCES Workstations(WorkstationID),
    CONSTRAINT FK_Assignments_Workers
        FOREIGN KEY (WorkerID) REFERENCES Workers(WorkerID),
    CONSTRAINT FK_Assignments_Orders
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE ProductionEvents (
    ProductionEventID INT IDENTITY(1,1) PRIMARY KEY,
    WorkstationID INT NOT NULL,
    WorkerID INT NOT NULL,
    OrderID INT NULL,
    EventType NVARCHAR(50) NOT NULL, -- LampStarted, LampCompleted, LampFailed
    CycleTimeSeconds INT NULL,
    EventTime DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    Notes NVARCHAR(255) NULL,
    CONSTRAINT FK_ProductionEvents_Workstations
        FOREIGN KEY (WorkstationID) REFERENCES Workstations(WorkstationID),
    CONSTRAINT FK_ProductionEvents_Workers
        FOREIGN KEY (WorkerID) REFERENCES Workers(WorkerID),
    CONSTRAINT FK_ProductionEvents_Orders
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE BinAlerts (
    BinAlertID INT IDENTITY(1,1) PRIMARY KEY,
    BinID INT NOT NULL,
    WorkstationID INT NOT NULL,
    AlertStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending', 
    AlertCreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    AlertDueAt DATETIME2 NOT NULL,
    MissedAt DATETIME2 NULL,
    RefilledAt DATETIME2 NULL,
    Notes NVARCHAR(255) NULL,
    CONSTRAINT FK_BinAlerts_Bins
        FOREIGN KEY (BinID) REFERENCES Bins(BinID),
    CONSTRAINT FK_BinAlerts_Workstations
        FOREIGN KEY (WorkstationID) REFERENCES Workstations(WorkstationID)
);

CREATE TABLE SystemLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    WorkstationID INT NULL,
    WorkerID INT NULL,
    BinID INT NULL,
    LogType NVARCHAR(50) NOT NULL,
    Message NVARCHAR(500) NOT NULL,
    LoggedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_SystemLogs_Workstations
        FOREIGN KEY (WorkstationID) REFERENCES Workstations(WorkstationID),
    CONSTRAINT FK_SystemLogs_Workers
        FOREIGN KEY (WorkerID) REFERENCES Workers(WorkerID),
    CONSTRAINT FK_SystemLogs_Bins
        FOREIGN KEY (BinID) REFERENCES Bins(BinID)
);

CREATE TABLE SystemConfig (
    ConfigID INT IDENTITY(1,1) PRIMARY KEY,
    ConfigKey NVARCHAR(100) NOT NULL UNIQUE,
    ConfigValue NVARCHAR(255) NOT NULL,
    Description NVARCHAR(255) NULL,
    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

-- Test information for the database
