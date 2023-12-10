-- QUERIES

-- 1. ispis imena i modela svih aviona s kapacitetom većim od 100
SELECT Name, Model
FROM Planes
WHERE Capacity > 100

-- 2. ispis svih karata čija je cijena između 100 i 200 eura
SELECT *
FROM Tickets
WHERE Price BETWEEN 100 AND 200

-- 3. ispis svih pilotkinja s više od 20 odrađenih letova do danas
SELECT *
FROM Pilots
WHERE Gender = 'Female' AND NumberOfFlights > 20


-- 4. ispis svih domaćina/ca zrakoplova koji su trenutno u zraku
SELECT FirstName, LastName, Position
FROM Staff
WHERE StatusOnFlight = 'On Air'

-- 5. ispis broja letova u Split/iz Splita 2023. godine
SELECT
    COUNT(*) AS NumberOfFlights
FROM
    Flights
WHERE
    (DepartureAirport IN (SELECT AirportID FROM Airports WHERE City = 'Split')
    OR DestinationAirport IN (SELECT AirportID FROM Airports WHERE City = 'Split'))
    AND EXTRACT(YEAR FROM DepartureTime) = 2023;


-- 6. ispis svih letova za Beč u prosincu 2023.
SELECT
    *
FROM
    Flights
WHERE
    (DepartureAirport IN (SELECT AirportID FROM Airports WHERE City = 'Vienna')
    OR DestinationAirport IN (SELECT AirportID FROM Airports WHERE City = 'Vienna'))
    AND EXTRACT(MONTH FROM DepartureTime) = 12
    AND EXTRACT(YEAR FROM DepartureTime) = 2023;
	
-- 7. ispis broj prodanih Economy letova kompanije AirDUMP u 2021.

SELECT
    COUNT(*) AS NumberOfSoldEconomyFlights
FROM
    Tickets
WHERE
    LEFT(Seat, 1) = 'A'
    AND FlightID IN (
        SELECT FlightID
        FROM Flights
        WHERE DepartureTime >= '2021-01-01' AND DepartureTime < '2022-01-01'
        AND Airline = 'AirDUMP'
    );
	
-- 8. ispis prosječne ocjene letova kompanije AirDUMP
SELECT
    AVG(Rating) AS AverageRating
FROM
    RatingsAndComments rac
WHERE
    EXISTS (
        SELECT 1
        FROM Flights f
        WHERE f.FlightID = rac.FlightID
        AND f.Airline = 'AirDUMP'
    );


-- 9. ispis svih aerodroma u Londonu, sortiranih po broju Airbus aviona trenutno na njihovim pistama
SELECT
    a.Name AS Airport,
    (SELECT COUNT(*)
     FROM Planes p
     WHERE p.AirportID = a.AirportID
       AND p.Name LIKE '%Airbus%') AS NumberOfAirbusPlanes
FROM
    Airports a
WHERE
    a.City = 'London'
GROUP BY
    a.AirportID, a.Name
ORDER BY
    NumberOfAirbusPlanes DESC;
	
-- 10. smanjite cijenu za 20% svim kartama čiji letovi imaju manje od 20 ljudi

UPDATE Tickets
SET Price = Price * 0.8  -- Decreasing the price by 20%
WHERE FlightID IN (
    SELECT FlightID
    FROM Flights
    WHERE NumberOfPassangers < 20
);

-- 11. povisite plaću za 100 eura svim pilotima koji su ove godine imali više od 10 letova duljih od 10 sati
UPDATE Pilots
SET Salary = Salary + 100
WHERE PilotID IN (
    SELECT DISTINCT PilotID
    FROM Flights
    WHERE EXTRACT(HOUR FROM (ArrivalTime - DepartureTime)) > 10
      AND EXTRACT(YEAR FROM DepartureTime) = EXTRACT(YEAR FROM CURRENT_DATE)
);

-- 12. razmontirajte avione starije od 20 godina koji nemaju letove pred sobom

UPDATE Planes
SET Status = 'Dismantled'
WHERE Status = 'Active'
    AND EXTRACT(YEAR FROM age(current_date, EntryDate)) > 20
    AND PlaneID NOT IN (
        SELECT PlaneID
        FROM Flights
        WHERE DepartureTime > current_date
    );
	
-- 13. izbrišite sve letove koji nemaju ni jednu prodanu kartu

DELETE FROM Flights
WHERE FlightID NOT IN (
    SELECT FlightID
    FROM Tickets
);

-- 14. izbrišite sve kartice vjernosti putnika čije prezime završava na -ov/a, -in/a
UPDATE Users
SET LoyaltyCard = FALSE
WHERE (LastName LIKE '%ov' OR LastName LIKE '%in') AND LoyaltyCard = TRUE;

