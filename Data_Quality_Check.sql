Select 

barcode,
count(*) over (partition by barcode) as cn

from takehome..products
where barcode is not null
order by cn desc, barcode;


Select * from takehome..products p
where p.barcode in 
(
400510,
404310
)
order by barcode;


Select 
receipt_id,
count(*) over (partition by receipt_id) as cn 
from takehome..transactions
where receipt_id is not null
order by cn desc, receipt_id;


Select * from takehome..transactions t
where t.receipt_id in 
(
'bedac253-2256-461b-96af-267748e6cecf',
'2acd7e8d-37df-4e51-8ee5-9a9c8c1d9711'
)
order by t.receipt_id;