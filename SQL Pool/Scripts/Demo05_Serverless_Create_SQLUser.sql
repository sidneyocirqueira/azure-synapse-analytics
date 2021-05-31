-- Create a read-only account to use later on
USE MASTER

CREATE LOGIN [reader] with password='Password';

USE SQLServerlessDB 

CREATE USER [reader] FROM LOGIN [reader];

ALTER ROLE db_datareader 
ADD MEMBER [reader] 

-- Grant permission to reader user
GRANT REFERENCES     
    ON DATABASE SCOPED CREDENTIAL ::[ProductSAS]  TO reader


