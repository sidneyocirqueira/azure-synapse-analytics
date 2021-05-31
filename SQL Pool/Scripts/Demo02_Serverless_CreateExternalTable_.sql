-- POLYBASE

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseParquetFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseParquetFormat] 
	WITH ( FORMAT_TYPE = PARQUET)
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'raw_storageaccount_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [raw_storageaccount_dfs_core_windows_net] 
	WITH (
		LOCATION   = 'https://storageaccount.dfs.core.windows.net/raw', 
	)
Go

CREATE EXTERNAL TABLE dbo.sales (
	[TransactionId] varchar(8000),
	[CustomerId] int,
	[ProductId] smallint,
	[Quantity] smallint,
	[Price] numeric(38,18),
	[TotalAmount] numeric(38,18),
	[TransactionDate] int,
	[ProfitAmount] numeric(38,18),
	[Hour] smallint,
	[Minute] smallint,
	[StoreId] smallint
	)
	WITH (
	LOCATION = 'sales/*.parquet',
	DATA_SOURCE = [raw_storageaccount_dfs_core_windows_net],
	FILE_FORMAT = [SynapseParquetFormat]
	)
GO

SELECT TOP 100 * FROM dbo.sales
GO

