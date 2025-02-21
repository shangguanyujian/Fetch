--Approach #1: Leading brand in 'Dips & Salsa' Category by # of Receipts
--CTE to get brands in 'Dips & Salsa' Category
with d_s as (select distinct

p.category_1,
p.category_2,
p.category_3,
p.category_4,
p.brand,
p.barcode,
t.receipt_id,
t.final_sale

from takehome..products p
join takehome..transactions t
on p.barcode = t.barcode
where category_2 = 'Dips & Salsa'
and brand is not null)

select distinct top 5

ds.category_2,
ds.brand,
count(*) over (partition by ds.brand) as cnReceipt

from d_s ds
order by cnReceipt desc
;



--Approach #2: Leading brand in 'Dips & Salsa' Category by Sales Amount
--CTE to get brands in 'Dips & Salsa' Category
with d_s as (select distinct

p.category_1,
p.category_2,
p.category_3,
p.category_4,
p.brand,
p.barcode,
t.receipt_id,
t.final_sale

from takehome..products p
join takehome..transactions t
on p.barcode = t.barcode

where category_2 = 'Dips & Salsa'
and brand is not null)

select distinct top 5

ds.category_2,
ds.brand,
round(sum(ds.final_sale) over (partition by ds.brand), 2) as accuSales

from d_s ds
order by accuSales desc
;