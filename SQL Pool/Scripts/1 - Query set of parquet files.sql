SELECT
        YEAR(tpepPickupDateTime) AS YEAR,
        passengerCount,
        COUNT(*) AS cnt
FROM  
    OPENROWSET(
        BULK 'https://datalakepassmarathon.dfs.core.windows.net/nyctlc/yellow/puYear=2019/puMonth=*/*.snappy.parquet',
        FORMAT='PARQUET'
    ) WITH (
        tpepPickupDateTime DATETIME2,
        passengerCount INT
    ) AS nyc
GROUP BY
    passengerCount,
    YEAR(tpepPickupDateTime)
ORDER BY
    YEAR(tpepPickupDateTime),
    passengerCount;

