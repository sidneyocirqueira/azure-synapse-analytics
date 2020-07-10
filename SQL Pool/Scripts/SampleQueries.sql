/* Compute Summary Statistics over dataset */

    SELECT b.Quartername,
           COUNT(a.PickupTimeID) AS "TotalTrips",
           SUM([TripDistanceMiles]) AS "TotalMiles",
           SUM([PassengerCount]) AS "TotalPassengers",
           AVG([FareAmount]) AS "AvgFare",
           MAX([FareAmount]) AS "MaxFare"
    FROM dbo.Trip a
    LEFT JOIN dbo.Date b ON a.[DateID] = b.[DateID]
    GROUP BY b.Quartername,
             b.Quarter
    ORDER BY b.Quarter
    
    
    /* Windowing functions - Find top 3 cities per county in NY state having a min of 100 trips */
    
    SELECT c.*
    FROM
      (SELECT b.County,
              b.city,
              count(a.dateid) AS total_trips,
              rank() OVER (PARTITION BY b.county
                           ORDER BY count(a.dateid) DESC) AS rank
       FROM dbo.Trip a
       LEFT JOIN dbo.Geography b ON a.[PickupGeographyID] = b.[GeographyID]
       WHERE State = 'NY'
       GROUP BY b.County,
                b.city) c
    WHERE rank <=3
      AND total_trips > 100
    ORDER BY County,
             City,
             total_trips,
             rank