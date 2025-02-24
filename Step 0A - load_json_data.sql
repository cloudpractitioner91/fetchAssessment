/*************************************************************************
--Step 1: Point to the right database
*************************************************************************/

use database fetchassessment;


/*************************************************************************
--Step 2: Create tables with variant data type to load semi-structure data
*************************************************************************/

--table receipts
create or replace table receipts (
  data VARIANT
);

--table users
create or replace table users (
  data VARIANT
);

--table brands
create or replace table brands (
  data VARIANT
);


/*************************************************************************
Step 3: Stage the JSON data
*************************************************************************/

create or replace stage json_stage
  file_format = (type = 'JSON');


/*************************************************************************
Step 4: Upload and list files in the stage json_stage created in Step 3
*************************************************************************/

list @json_stage;


/*************************************************************************
Step 5: Copy data from staged files into respective tables
*************************************************************************/

--load receipts
copy into receipts (data)
FROM @json_stage/receipts.json
FILE_FORMAT = (TYPE = 'JSON');

--load users
copy into users (data)
FROM @json_stage/users.json
FILE_FORMAT = (TYPE = 'JSON');

--load brands
copy into brands (data)
FROM @json_stage/brands.json
FILE_FORMAT = (TYPE = 'JSON');


/*************************************************************************
Step 6: Query sample data
*************************************************************************/

--head receipts
select *
from receipts
limit 10;

--head users
select *
from users
limit 100;

--head brands
select *
from brands
limit 100;