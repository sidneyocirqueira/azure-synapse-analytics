-- DEMO EXTERNAL TABLE - POLYBASE

-- Required to create credentials
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Password'
GO

-- Create credential that enables access to SAS-protected
CREATE DATABASE SCOPED CREDENTIAL [DataLakeSAS]
WITH IDENTITY='SHARED ACCESS SIGNATURE',  
SECRET = ''
GO

-- the external data source points to the Azure Data Lake folder

CREATE EXTERNAL DATA SOURCE Datalake
WITH ( LOCATION = 'https://storageaccount.dfs.core.windows.net/',
       CREDENTIAL = [DataLakeSAS] )
GO

-- create external file format
CREATE EXTERNAL FILE FORMAT NativeParquet
WITH (  
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
);
GO

-- Create External Table As Select (CETAS)


CREATE EXTERNAL TABLE [dbo].[sales_agg]
WITH (DATA_SOURCE = Datalake, LOCATION = 'report/sales_agg', FILE_FORMAT = [NativeParquet])
AS  SELECT
    TransactionDate, ProductId,
        CAST(SUM(ProfitAmount) AS decimal(18,2)) AS [(sum) Profit],
        CAST(AVG(ProfitAmount) AS decimal(18,2)) AS [(avg) Profit],
        SUM(Quantity) AS [(sum) Quantity]
FROM
    OPENROWSET(
        BULK 'https://storageaccount.dfs.core.windows.net/raw/sales/sale-small-20191230-snappy.parquet',
        FORMAT='PARQUET'
    ) AS [r] GROUP BY r.TransactionDate, r.ProductId;


SELECT TOP 100 * FROM [dbo].[sales_agg]
