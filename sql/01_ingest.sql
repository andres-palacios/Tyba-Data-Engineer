CREATE OR REPLACE VIEW raw_t AS
SELECT * FROM read_parquet('{T_FILE}');

CREATE OR REPLACE VIEW raw_t1 AS
SELECT * FROM read_parquet('{T1_FILE}');