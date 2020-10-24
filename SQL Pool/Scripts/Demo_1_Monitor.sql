-- View your data as it loads.
SELECT  r.[request_id]                           
,       r.[status]                               
,       r.resource_class                         
,       r.command
,       sum(bytes_processed) AS bytes_processed
,       sum(rows_processed) AS rows_processed
FROM    sys.dm_pdw_exec_requests r
              JOIN sys.dm_pdw_dms_workers w
                     ON r.[request_id] = w.request_id
WHERE [label] = 'COPY : Load [dbo].[Date] - Taxi dataset' OR
    [label] = 'COPY : Load [dbo].[Geography] - Taxi dataset' OR
    [label] = 'COPY : Load [dbo].[HackneyLicense] - Taxi dataset' OR
    [label] = 'COPY : Load [dbo].[Medallion] - Taxi dataset' OR
    [label] = 'COPY : Load [dbo].[Time] - Taxi dataset' OR
    [label] = 'COPY : Load [dbo].[Weather] - Taxi dataset' OR
    [label] = 'COPY : Load [dbo].[Trip] - Taxi dataset' 
and session_id <> session_id() and type = 'WRITER'
GROUP BY r.[request_id]                           
,       r.[status]                               
,       r.resource_class                         
,       r.command;