--CTE to calculate account duration
with accDuration as (Select
u.id as user_id,
DATEDIFF(MONTH, CREATED_DATE, getdate()) - 
    CASE 
        WHEN DAY(CREATED_DATE) > DAY(getdate()) THEN 1 
        ELSE 0 
    END AS acc_Duration

from takehome..users u)

--CTE to calculate orders from account > 6 months
,saleBrand as (Select
t.barcode,
p.brand,
t.user_id,
d.acc_Duration,
t.final_sale

from takehome..transactions t
join takehome..products p
on p.barcode = t.barcode
join accDuration d
on t.user_id = d.user_id
and d.acc_Duration >= 6)

--CTE to sum the sales by brand and eliminate records missing brand data
,finalData as (Select distinct 
s.brand,
sum(s.final_sale) over (partition by s.brand) as accuSales
from saleBrand s
where s.brand is not null)

--CTE to get the final dataset on brand, accuSales and ranking
, finalrank as (Select 
*,
rank() over (order by accuSales desc) as ranking
from finaldata)

Select * from finalrank
where ranking <= 5
order by accuSales desc
;
