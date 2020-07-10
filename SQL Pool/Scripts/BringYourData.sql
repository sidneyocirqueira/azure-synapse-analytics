/*This sample uses COPY command to load data. You can either modify parameters or use BulkCopy utility by right clicking data from storage account to generate this script for loading your own data */
 
    IF NOT EXISTS (SELECT * FROM information_schema.tables WHERE table_name = 'Weather')
        CREATE TABLE [dbo].[Weather](
            [usaf] [nvarchar](200) NULL,
            [wban] [nvarchar](200) NULL,
            [datetime] [datetime] NULL,
            [latitude] [float] NULL,
            [longitude] [float] NULL,
            [elevation] [float] NULL,
            [windAngle] [int] NULL,
            [windSpeed] [float] NULL,
            [temperature] [float] NULL,
            [seaLvlPressure] [float] NULL,
            [cloudCoverage] [nvarchar](200) NULL,
            [presentWeatherIndicator] [int] NULL,
            [pastWeatherIndicator] [int] NULL,
            [precipTime] [float] NULL,
            [precipDepth] [float] NULL,
            [snowDepth] [float] NULL,
            [stationName] [nvarchar](200) NULL,
            [countryOrRegion] [nvarchar](200) NULL,
            [p_k] [nvarchar](200) NULL,
            [year] [int] NULL,
            [day] [int] NULL,
            [version] [float] NULL,
            [month] [int] NULL
        )
        WITH
        (
            DISTRIBUTION = ROUND_ROBIN,
            CLUSTERED COLUMNSTORE INDEX
        )
        GO
    
    COPY INTO Weather FROM 'https://azureopendatastorage.blob.core.windows.net/isdweatherdatacontainer/ISDWeather/year=2018/month=2/'
    WITH (
       FILE_TYPE = 'PARQUET',
       CREDENTIAL=(IDENTITY= 'Shared Access Signature', SECRET='""')
    ) OPTION (LABEL = 'COPY: Getting started');