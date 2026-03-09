-- Using statements
USE FogLampManufacturing;
GO
    
-- Creating the Database
CREATE DATABASE FogLampManufacturing;

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
INSERT INTO Workers (EmployeeNumber, FirstName, LastName, ExperienceLevel, EfficiencyRating)
VALUES
('E1001', 'John', 'Carter', 3, 1.15),
('E1002', 'Sarah', 'Nguyen', 2, 1.00),
('E1003', 'Mike', 'Patel', 1, 0.85),
('E1004', 'Emma', 'Lopez', 4, 1.25),
('E1005', 'Chris', 'Moore', 2, 0.95);
GO

INSERT INTO Workstations (StationName, StationNumber)
VALUES
('Housing Assembly', 1),
('Lens Mounting', 2),
('Wiring Assembly', 3),
('Final Inspection', 4),
('Packaging', 5);
GO

INSERT INTO Orders (OrderNumber, LampType, TargetQuantity, CompletedQuantity, FailedQuantity, Status)
VALUES
('ORD-1001', 'Fog Lamp A', 500, 125, 8, 'InProgress'),
('ORD-1002', 'Fog Lamp B', 250, 40, 3, 'Pending');
GO

INSERT INTO Bins (WorkstationID, BinName, CurrentLevel, MaxLevel, LowThreshold, Status)
VALUES
(1, 'Housing Units', 40, 50, 10, 'OK'),
(1, 'Mount Screws', 12, 50, 10, 'OK'),
(2, 'Lens Covers', 8, 40, 10, 'Low'),
(2, 'Seal Kits', 25, 40, 8, 'OK'),
(3, 'Wiring Harnesses', 6, 30, 8, 'Low'),
(3, 'Connectors', 20, 30, 6, 'OK'),
(4, 'Inspection Labels', 15, 25, 5, 'OK'),
(5, 'Packaging Boxes', 18, 30, 6, 'OK');
GO

INSERT INTO WorkstationAssignments (WorkstationID, WorkerID, OrderID, Status)
VALUES
(1, 1, 1, 'Working'),
(2, 2, 1, 'Working'),
(3, 3, 1, 'Waiting'),
(4, 4, 1, 'Working'),
(5, 5, 2, 'Waiting');
GO

INSERT INTO ProductionEvents (WorkstationID, WorkerID, OrderID, EventType, CycleTimeSeconds, Notes)
VALUES
(1, 1, 1, 'LampStarted', 55, 'Started new housing assembly'),
(1, 1, 1, 'LampCompleted', 58, 'Completed housing stage'),
(2, 2, 1, 'LampStarted', 65, 'Lens mounting started'),
(2, 2, 1, 'LampFailed', 72, 'Seal issue found'),
(4, 4, 1, 'LampCompleted', 50, 'Inspection passed');
GO

INSERT INTO BinAlerts (BinID, WorkstationID, AlertStatus, AlertCreatedAt, AlertDueAt, Notes)
VALUES
(3, 2, 'Pending', DATEADD(MINUTE, -2, SYSDATETIME()), DATEADD(MINUTE, 3, SYSDATETIME()), 'Lens Covers running low'),
(5, 3, 'Missed', DATEADD(MINUTE, -8, SYSDATETIME()), DATEADD(MINUTE, -3, SYSDATETIME()), 'Runner missed refill time');
GO

INSERT INTO SystemLogs (WorkstationID, WorkerID, BinID, LogType, Message)
VALUES
(1, 1, 1, 'Production', 'Worker started housing assembly'),
(1, 1, 1, 'Production', 'Housing assembly completed'),
(2, 2, 3, 'Alert', 'Lens Covers bin flagged low'),
(3, 3, 5, 'Alert', 'Wiring Harnesses bin refill missed'),
(4, 4, NULL, 'Inspection', 'Fog lamp passed final inspection');
GO

INSERT INTO SystemConfig (ConfigKey, ConfigValue, Description)
VALUES
('SimulationSpeedMultiplier', '1.0', 'Controls workstation simulation speed'),
('RunnerResponseMinutes', '5', 'Minutes allowed before refill is marked missed'),
('DefaultLampBuildSeconds', '60', 'Default build time for one lamp'),
('DashboardRefreshSeconds', '3', 'Refresh interval for dashboard screens'),
('AndonRefreshSeconds', '2', 'Refresh interval for workstation Andon display');
GO
