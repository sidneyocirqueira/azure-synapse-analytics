SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://storageaccount.dfs.core.windows.net/raw/customer/customerinfo.csv',
        FORMAT = 'CSV',
        PARSER_VERSION='2.0'
    ) AS [result]

CREATE VIEW CustomerInfo AS
    SELECT * 
FROM OPENROWSET(
        BULK 'https://storageaccount.dfs.core.windows.net/raw/customer/customerinfo.csv',
        FORMAT = 'CSV',
        PARSER_VERSION='2.0',
        FIRSTROW=2
    )
WITH (
    [UserName] VARCHAR (50),
    [Gender] VARCHAR (10),
    [Phone] VARCHAR (50),
    [Email] VARCHAR (100),
    [CreditCard] VARCHAR (50)
) AS [r];
GO

SELECT * FROM CustomerInfo;
GO

