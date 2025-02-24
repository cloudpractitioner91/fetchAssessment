# Fetch-Take-Home-Assessment

I will attempt to articulate steps taken towards completing this assessment here. 

* __Step 0A__:
Created a database _'fetchassessment'_ on my instance of snowflake (free-trial). Next, I needed to create three tables, each of a variant data type to hold the unstructured JSON data from the three files; receipts, users, and brands. Lastly, I created a stage in snowflake, uploaded the JSON files, and copied them over to the tables. Please refer to [Step 0A - load_json_data.sql](https://github.com/hamdm/fetchAssessment/blob/main/Step%200A%20-%20load_json_data.sql)

* __Step 0B__:
Tranformed the JSON data into structured tables. 
I had to use Snowflake's _Lateral Flatten_ to explode receipts_items_list, and identify all the distinct keys within. 
Refer to [Step 0B - transform_data.sql](https://github.com/hamdm/fetchAssessment/blob/main/Step%200B%20-%20transform_data.sql)

* __Step 1__:
Used Lucid to create the [ER Diagram](https://github.com/hamdm/fetchAssessment/blob/main/Step%201%20-%20ER%20Diagram.jpeg).

* __Step 2__:
Please refer to [Step 2 - queries.sql](https://github.com/hamdm/fetchAssessment/blob/main/Step%202%20-%20queries.sql) that attempts to answer the following;
  - When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
  - When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

* __Step 3__:
Ran some queries ([Step 3 - data_quality_issues.sql](https://github.com/hamdm/fetchAssessment/blob/main/Step%203%20-%20data_quality_issues.sql)) to identify data quality issues. Please note these queries can be replicated for other tables as well. 
   - The pointsearned field in the receipts table is nearly always null. Is this expected? If not, we may need to address this at the source.
   - Several fields, such as BONUSPOINTSEARNED, BONUSPOINTSEARNEDREASON, POINTSAWARDEDDATE, FINISHEDDATE, and PURCHASEDITEMCOUNT, are null approximately 50% of the time.
   - The totalspent field is missing values in 40% of the records, which is concerning. Could you clarify the business implications of this data gap?
   - Identified at least 148 receipts where we were unable to map the userId to the dim_users table.
   - I also conducted a quick check comparing totalspent in the receipts to the total price in the receipts' item list. 
       There are 57 receipts where the values do not match. While the discrepancy is not too large, I wanted to confirm if I’m using the correct field. I used finalPrice, 
       but should I be referencing item price instead?

* __Step 4__:
Please refer to [Step 4 - Communicate to stakeholder.txt](https://github.com/hamdm/fetchAssessment/blob/main/Step%204%20-%20Communicate%20to%20stakeholder.txt).
