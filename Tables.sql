-- Airports
CREATE TABLE Airports (
    AirportID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    City VARCHAR(255) NOT NULL,
    RunwayCapacity INT NOT NULL,
    StorageCapacity INT NOT NULL
);

-- Planes
CREATE TABLE Planes (
    PlaneID SERIAL PRIMARY KEY,
    AirportID INT REFERENCES Airports(AirportID),
    Status VARCHAR(50) NOT NULL,
    Capacity INT NOT NULL
);

ALTER TABLE Planes
ADD COLUMN Name VARCHAR(50) NOT NULL,
ADD COLUMN Model VARCHAR(50) NOT NULL

ALTER TABLE Planes
ADD COLUMN EntryDate TIMESTAMP NOT NULL


-- Flights
CREATE TABLE Flights (
    FlightID SERIAL PRIMARY KEY,
    PlaneID INT REFERENCES Planes(PlaneID),
    DepartureAirport INT REFERENCES Airports(AirportID),
    DestinationAirport INT REFERENCES Airports(AirportID),
    DepartureTime TIMESTAMP NOT NULL,
    ArrivalTime TIMESTAMP NOT NULL,
    FlightCapacity INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);

ALTER TABLE Flights 
ADD COLUMN NumberOfPassangers INT NOT NULL

ALTER TABLE Flights
ADD COLUMN Airline VARCHAR(50)

-- Tickets
CREATE TABLE Tickets (
    TicketID SERIAL PRIMARY KEY,
    FlightID INT REFERENCES Flights(FlightID),
    UserID INT REFERENCES Users(UserID),
    Seat VARCHAR(10) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    PurchaseTime TIMESTAMP NOT NULL,
    LoyaltyCard BOOLEAN
);

-- Users
CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    PurchasedTicketsCount INT DEFAULT 0,
    LoyaltyCard BOOLEAN
);

-- Staff
CREATE TABLE Staff (
    StaffID SERIAL PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Age INT NOT NULL,
    Position VARCHAR(50) NOT NULL,
    FlightID INT REFERENCES Flights(FlightID),
    StatusOnFlight VARCHAR(50) NOT NULL,
);
-- Pilots
CREATE TABLE Pilots (
    PilotID SERIAL PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Age INT NOT NULL,
    FlightID INT REFERENCES Flights(FlightID),
    CONSTRAINT CheckPilotAge CHECK (Age BETWEEN 20 AND 60)
);

ALTER TABLE Pilots
ADD COLUMN Salary DECIMAL(10, 2) NOT NULL

ALTER TABLE Pilots
ADD COLUMN Gender VARCHAR(40) NOT NULL,
ADD COLUMN NumberOfFlights INT NOT NULL


-- RatingsAndComments
CREATE TABLE RatingsAndComments (
    RatingID SERIAL PRIMARY KEY,
    FlightID INT REFERENCES Flights(FlightID),
    UserID INT REFERENCES Users(UserID),
    Rating INT NOT NULL,
    Comment TEXT,
    Anonymous BOOLEAN
);
