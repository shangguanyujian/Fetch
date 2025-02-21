--CTE to calculate users' age based on current date - birth_date
with userAge as (Select
u.id as user_id,
u.BIRTH_DATE,
DATEDIFF(YEAR, BIRTH_DATE, GETDATE()) - 
    CASE 
        WHEN DATEADD(YEAR, DATEDIFF(YEAR, BIRTH_DATE, GETDATE()), BIRTH_DATE) > GETDATE() 
        THEN 1 
        ELSE 0 
    END AS user_age

from takehome..users u)

--CTE to count the receipts by brand
,transBrand as (Select
t.receipt_id,
t.barcode,
p.brand,
t.user_id,
a.user_age,
count(*) over (partition by brand) as count_Receipts

from takehome..transactions t
join takehome..products p
on p.barcode = t.barcode
join userAge a
on t.user_id = a.user_id
and a.user_age > 21)

--CTE to aggregate the count by brand and eliminate records missing brand data
,finaldata as (select distinct
brand,
count_Receipts
from transBrand b
where b.brand is not null)

--CTE to get the final dataset on brand, number of receipts and ranking
, finalrank as (Select 
*,
rank() over (order by count_Receipts desc) as ranking
from finaldata)

Select * from finalrank
where ranking <= 5
order by count_Receipts desc
;


