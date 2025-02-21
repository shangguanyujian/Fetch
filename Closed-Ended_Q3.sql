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
,userGen as (Select
a.user_id,
a.user_age,
CASE WHEN a.user_age < 18 THEN 'Youth'
	WHEN a.user_age <30 THEN 'Young Adult'
	WHEN a.user_age <50 THEN 'Adult'
	WHEN a.user_age <70 THEN 'Old'
	WHEN a.user_age >= 70 THEN 'Senior'
END as user_Gen

from userAge a)

--CTE to hold health and wellness products
,h_w as (select distinct

p.category_1,
p.category_2,
p.category_3,
p.category_4,
p.brand,
p.barcode,
t.receipt_id,
t.final_sale,
t.user_id,
u.user_Gen

from takehome..products p
join takehome..transactions t
on p.barcode = t.barcode
join userGen u
on u.user_id = t.user_id

where category_1 = 'Health & Wellness'
and brand is not null)
--Select * from h_w;

,sale_Gen as (Select distinct

category_1,
user_Gen,
sum(final_sale) over (partition by user_Gen) as sale_Gen

from h_w)
Select 

category_1 as product_category,
user_Gen,
round(sale_Gen, 3) as sale_Gen,
round(sale_Gen/ (Select sum(sale_Gen) from sale_Gen) * 100, 2) as sale_Percentage
from sale_Gen;

