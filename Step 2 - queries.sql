-- When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
select 
    rewardreceiptstatus,
    avg(totalspend) avg_spend
from fetchassessment.public.fct_receipts
where rewardreceiptstatus ilike any ('finish%','reject%')
group by 1
order by avg_spend desc
limit 1
;

--When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
select 
    rewardreceiptstatus,
    sum(purchaseditemcount) ttl_count
from fetchassessment.public.fct_receipts
where rewardreceiptstatus ilike any ('finish%','reject%')
group by 1
order by ttl_count desc
limit 1
;