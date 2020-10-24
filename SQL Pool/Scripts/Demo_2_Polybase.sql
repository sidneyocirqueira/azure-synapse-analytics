-- If you do not have a Master Key on your DW you will need to create one.
CREATE MASTER KEY;

CREATE DATABASE SCOPED CREDENTIAL ADLS_CREDENTIAL
WITH
  IDENTITY = '[nome do seu storage account]' ,
  SECRET = '[informe sua credencial]'
;

-- Note this example uses a Gen 2 secured endpoint (abfss)

CREATE EXTERNAL DATA SOURCE NYCTLC
WITH
  ( LOCATION = 'abfss://container@storageaccount.dfs.core.windows.net', 
    CREDENTIAL = ADLS_CREDENTIAL ,
    TYPE = HADOOP
  ) ;
  
CREATE SCHEMA ext;
GO
-- DROP EXTERNAL FILE FORMAT ParquetFileFormat
GO
CREATE EXTERNAL FILE FORMAT ParquetFileFormat  
WITH (  
    FORMAT_TYPE = PARQUET,  
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'  
);
GO
-- Drop external table ext.trip
CREATE EXTERNAL TABLE ext.Trip (
	[vendorID] varchar(8000),
	[tpepPickupDateTime] datetime2(7),
	[tpepDropoffDateTime] datetime2(7),
	[passengerCount] int,
	[tripDistance] float,
	[puLocationId] varchar(8000),
	[doLocationId] varchar(8000),
	[startLon] float,
	[startLat] float,
	[endLon] float,
	[endLat] float,
	[rateCodeId] int,
	[storeAndFwdFlag] varchar(8000),
	[paymentType] varchar(8000),
	[fareAmount] float,
	[extra] float,
	[mtaTax] float,
	[improvementSurcharge] varchar(8000),
	[tipAmount] float,
	[tollsAmount] float,
	[totalAmount] float
	)
	WITH (
	LOCATION = 'yellow/puYear=2013/',
	DATA_SOURCE = [NYCTLC],
	FILE_FORMAT = [ParquetFileFormat]
	)
GO
-- Tempo total apenas mês 3 = 1 min
-- Qnt de linhas = 15.752.632

-- Tempo total todos os meses = 10 min
-- Qnt de linhas = 15.752.632

-- CTAS

-- DROP TABLE dbo.Trip_Polybase
CREATE TABLE dbo.Trip_Polybase
WITH
(
 DISTRIBUTION = ROUND_ROBIN
 ,CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT * FROM ext.Trip
GO
-- Tempo total para criar tabela fisica = 10 min (100 DWUs)

select count(*)
from [dbo].[Trip_Polybase]


