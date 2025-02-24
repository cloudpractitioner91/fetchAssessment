use database fetchassessment;
/**************************************************************************
--Data quality issues for fct_receipts (can be replicated for other tables)
**************************************************************************/
--Pull all column names for subsequent queries
select
    column_name
from
    fetchassessment.information_schema.columns
where
    table_name = 'FCT_RECEIPTS';
    
--Checking for nulls
with count_nulls as (
    select
        'count_nulls' as col_stat,
        sum(
            case
                when CREATEDATE is null then 1
                else 0
            end
        ) as CREATEDATE,
        sum(
            case
                when POINTSEARNED is null then 1
                else 0
            end
        ) as POINTSEARNED,
        sum(
            case
                when USERID is null then 1
                else 0
            end
        ) as USERID,
        sum(
            case
                when BONUSPOINTSEARNED is null then 1
                else 0
            end
        ) as BONUSPOINTSEARNED,
        sum(
            case
                when BONUSPOINTSEARNEDREASON is null then 1
                else 0
            end
        ) as BONUSPOINTSEARNEDREASON,
        sum(
            case
                when POINTSAWARDEDDATE is null then 1
                else 0
            end
        ) as POINTSAWARDEDDATE,
        sum(
            case
                when DATESCANNED is null then 1
                else 0
            end
        ) as DATESCANNED,
        sum(
            case
                when FINISHEDDATE is null then 1
                else 0
            end
        ) as FINISHEDDATE,
        sum(
            case
                when PURCHASEDITEMCOUNT is null then 1
                else 0
            end
        ) as PURCHASEDITEMCOUNT,
        sum(
            case
                when ID is null then 1
                else 0
            end
        ) as ID,
        sum(
            case
                when MODIFYDATE is null then 1
                else 0
            end
        ) as MODIFYDATE,
        sum(
            case
                when PURCHASEDATE is null then 1
                else 0
            end
        ) as PURCHASEDATE,
        sum(
            case
                when REWARDRECEIPTSTATUS is null then 1
                else 0
            end
        ) as REWARDRECEIPTSTATUS,
        sum(
            case
                when TOTALSPEND is null then 1
                else 0
            end
        ) as TOTALSPEND,
    from
        fct_receipts
),
ttl_rows as (
    select
        count(*) ttl_count
    from
        fct_receipts
),
unpivot_nulls as (
    select
        *
    from
        count_nulls unpivot (
            nulls for col in (
                CREATEDATE,
                POINTSEARNED,
                BONUSPOINTSEARNED,
                USERID,
                BONUSPOINTSEARNEDREASON,
                POINTSAWARDEDDATE,
                DATESCANNED,
                FINISHEDDATE,
                PURCHASEDITEMCOUNT,
                ID,
                TOTALSPEND,
                MODIFYDATE,
                PURCHASEDATE,
                REWARDRECEIPTSTATUS
            )
        )
)
select
    un.*,
    round((un.nulls / ttl_count) * 100) as pct_nulls
from
    unpivot_nulls un,
    ttl_rows
;

--Verifying foreign key integrity for dim_users
select
    fr.id,
    fr.userId
from
    fct_receipts fr
    left join dim_users du on fr.userId = du.id
where
    du.id is null;

--Verify that finishedDate is always after createDate
select id, createDate, finishedDate
from fct_receipts
where finishedDate < createDate;

--Check for dupes
select
    id,
    count(*)
from 
    fct_receipts
group by 1
order by 2 desc;

--Verify that the totalspend in the receipts matches to sum of the individual items on the receipts items list
select
    fr.id,
    fr.totalspend,
    sum(fril.finalprice) as finalprice
from 
fct_receipts fr
left join fct_receipts_items_list fril
    on fr.id = fril.receipt_id
group by 1,2
having sum(fril.finalprice) != fr.totalspend
;