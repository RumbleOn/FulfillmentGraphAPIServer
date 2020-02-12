ALTER TABLE appointments 
ALTER COLUMN location TYPE
INT USING location::integer;