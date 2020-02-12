ALTER TABLE locations 
ADD COLUMN sourceId integer;

UPDATE locations
SET sourceId = 99
WHERE
   name = 'Irving HQ';

UPDATE locations
SET sourceId = 30
WHERE
   name = 'Las Vegas';

ALTER TABLE locations ADD UNIQUE (sourceId);