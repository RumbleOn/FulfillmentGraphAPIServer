INSERT INTO locations
  (name, polygon)
VALUES
  (
    'Irving HQ',
    ST_GeometryFromText('POLYGON((-96.9620007 32.8870879,-96.9620007 32.8855112,-96.9601178 32.8855112,-96.9601232 32.8876194,-96.9619739 32.8876419,-96.9620007 32.8870879))')
);

INSERT INTO locations
  (name, polygon)
VALUES
  (
    'Las Vegas',
    ST_GeometryFromText('POLYGON((-115.024361 36.2810153,-115.0253695 36.2814759,-115.026319 36.2807494,-115.0252086 36.2800294,-115.024361 36.2810153))')
);