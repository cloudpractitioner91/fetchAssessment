use database fetchassessment;

/*************************************************************************
--Transform raw users table
*************************************************************************/
create
or replace table dim_users as
select
    data:"_id":"$oid"::string as id,
    data:"active"::boolean as active,
    data:"createdDate":"$date"::int as createdDate,
    data:"lastLogin":"$date"::int as lastLogin,
    data:"role"::string as role,
    data:"signUpSource"::string as signUpSource,
    data:"state"::string as state
from
    fetchassessment.public.users
;


/*************************************************************************
--Transform raw brands table
*************************************************************************/
create
or replace table dim_brands as
select
    data:"_id":"$oid"::string as id,
    data:"barcode"::string as barcode,
    data:"brandCode"::string as brandcode,
    data:"category"::string as category,
    data:"categoryCode"::string as categoryCode,
    data:"cpg":"$id":"$oid"::string as cpg_id,
    data:"name"::string as name,
    data:"topBrand"::string as topBrand
from
    fetchassessment.public.brands
;

/*************************************************************************
--Transform raw receipts table
*************************************************************************/
create
or replace table fct_receipts as
select 
    data:"_id":"$oid"::string as id,
    data:"bonusPointsEarned"::number as bonusPointsEarned,
    data:"bonusPointsEarnedReason"::string as bonusPointsEarnedReason,
    data:"createDate":"$date"::int as createDate, 
    data:"dateScanned":"$date"::int as dateScanned, 
    data:"finishedDate":"$date"::int as finishedDate,
    data:"modifyDate":"$date"::int as modifyDate,
    data:"pointsAwardedDate":"$date"::int as pointsAwardedDate,
    data:"pointsEarned":"$date"::number as pointsEarned,
    data:"purchaseDate":"$date"::int as purchaseDate,
    data:"purchasedItemCount"::int as purchasedItemCount, 
    data:"rewardsReceiptStatus"::string as rewardReceiptStatus,
    data:"totalSpent"::number as totalSpend,
    data:"userId"::string as userId
from
    fetchassessment.public.receipts
;


/*************************************************************************
--Identify distinct keys in rewardsReceiptItemList, and create items table
*************************************************************************/
--Identify keys
with flattened_data as (
    select
        r.data:"_id":"$oid"::string as id,
        f.value as flattened_value
    from
        fetchassessment.public.receipts r,
        lateral flatten(input => r.data:"rewardsReceiptItemList") AS f
),
flattened_keys as (
select  
    fd.id,
    fv.*
from flattened_data fd,
lateral flatten(input => object_keys(flattened_value)) fv
)
select distinct value from flattened_keys order by value
;

--Create sequence for PK
create or replace sequence my_sequence start = 1 increment = 1;

--Create table
create or replace table fct_receipts_items_list as
with flattened_data as (
    select
        r.data:"_id":"$oid"::string as id,
        f.value as flattened_value
    from
        fetchassessment.public.receipts r,
        lateral flatten(input => r.data:"rewardsReceiptItemList") AS f
)
select 
     my_sequence.NEXTVAL as _id
    ,id as receipt_id
    ,flattened_value:"barcode"::string as barcode
    ,flattened_value:"brandCode"::string as brandCode
    ,flattened_value:"competitiveProduct"::boolean as competitiveProduct
    ,flattened_value:"competitorRewardsGroup"::string as competitorRewardsGroup
    ,flattened_value:"deleted"::boolean as deleted
    ,flattened_value:"description"::string as description
    ,flattened_value:"discountedItemPrice"::number as discountedItemPrice
    ,flattened_value:"finalPrice"::number as finalPrice
    ,flattened_value:"itemNumber"::string as itemNumber
    ,flattened_value:"itemPrice"::number as itemPrice
    ,flattened_value:"metabriteCampaignId"::string as metabriteCampaignId
    ,flattened_value:"needsFetchReview"::boolean as needsFetchReview
    ,flattened_value:"needsFetchReviewReason"::string as needsFetchReviewReason
    ,flattened_value:"originalFinalPrice"::number as originalFinalPrice
    ,flattened_value:"originalMetaBriteBarcode"::string as originalMetaBriteBarcode
    ,flattened_value:"originalMetaBriteDescription"::string as originalMetaBriteDescription
    ,flattened_value:"originalMetaBriteItemPrice"::number as originalMetaBriteItemPrice
    ,flattened_value:"originalMetaBriteQuantityPurchased"::int as originalMetaBriteQuantityPurchased
    ,flattened_value:"originalReceiptItemText"::string as originalReceiptItemText
    ,flattened_value:"partnerItemId"::string as partnerItemId
    ,flattened_value:"pointsEarned"::number as pointsEarned
    ,flattened_value:"pointsNotAwardedReason"::string as pointsNotAwardedReason
    ,flattened_value:"pointsPayerId"::string as pointsPayerId
    ,flattened_value:"preventTargetGapPoints"::number as preventTargetGapPoints
    ,flattened_value:"priceAfterCoupon"::number as priceAfterCoupon
    ,flattened_value:"quantityPurchased"::int as quantityPurchased
    ,flattened_value:"rewardsGroup"::string as rewardsGroup
    ,flattened_value:"rewardsProductPartnerId"::string as rewardsProductPartnerId
    ,flattened_value:"targetPrice"::number as targetPrice
    ,flattened_value:"userFlaggedBarcode"::string as userFlaggedBarcode
    ,flattened_value:"userFlaggedDescription"::string as userFlaggedDescription
    ,flattened_value:"userFlaggedNewItem"::boolean as userFlaggedNewItem
    ,flattened_value:"userFlaggedPrice"::number as userFlaggedPrice
    ,flattened_value:"userFlaggedQuantity"::int as userFlaggedQuantity
from 
    flattened_data
;

select * from fct_receipts_items_list order by _id limit 100;