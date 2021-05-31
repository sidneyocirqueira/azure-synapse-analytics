SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://storageaccount.dfs.core.windows.net/raw/sales/sale-small-20191230-snappy.parquet',
        FORMAT='PARQUET'
    ) AS [result]


SELECT
    TransactionDate, ProductId,
        CAST(SUM(ProfitAmount) AS decimal(18,2)) AS [(sum) Profit],
        CAST(AVG(ProfitAmount) AS decimal(18,2)) AS [(avg) Profit],
        SUM(Quantity) AS [(sum) Quantity]
FROM
    OPENROWSET(
        BULK 'https://storageaccount.dfs.core.windows.net/raw/sales/sale-small-20191230-snappy.parquet',
        FORMAT='PARQUET'
    ) AS [r] GROUP BY r.TransactionDate, r.ProductId;

SELECT
    COUNT(*)
FROM
    OPENROWSET(
        BULK 'https://storageaccount.dfs.core.windows.net/raw/sales/*',
        FORMAT='PARQUET'
    ) AS [r];

    -- 1.469.861



