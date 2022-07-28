-------------------------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      July 2022
-- Purpose      Identify duplicate claim lines and seperate out reversals, originals and adjustment.
-- Notes        First, duplicate claim lines are identified
--              Then, reversals for are identified.  The payments of these lines are negative.
--              Next, the original lines are identified.  The charge or paid amount of an orginial
--                is the same amount as the reversal
--              Finally, the adjusted lines are identified.  This is the claim line that hasn't been
--                flagged as original or reversal
--              Edge cases:  Not all lines on a claim will be reversed.  These lines are definied
--                as an adjustment so they are included in the final data set.
--              Some duplicate claims do not have a reversal indicator so they are entirely removed.
-------------------------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------------------------

with  reversals as(
  select 
    'R' as adjustment_type
    , l.* 
  from {{ ref('duplicate_claims')}} d
  inner join {{ var('medical_claims_line')}} l
    on d.claim_id = l.claim_id
    and d.line_no = l.line_no
  where (plan_paid_amt < 0
  or charge_amt < 0)
)
, original as(
select 'O' as adjustment_type, l.* 
from reversals r
inner join {{ var('medical_claims_line')}} l
  on r.claim_id = l.claim_id
  and r.line_no = l.line_no
where r.plan_paid_amt * -1 = l.plan_paid_amt
and r.charge_amt * -1 = l.charge_amt
)
, adjustment as(
select 
  'A' as adjustment_type
  , l.* 
from {{ var('medical_claims_line')}} l
left join reversals r
  on l.claim_id = r.claim_id
  and l.line_no = r.line_no
where l.claim_id in (select claim_id from reversals)
and l.plan_paid_amt <> ifnull(r.plan_paid_amt,0)
and l.plan_paid_amt <> ifnull(r.plan_paid_amt* -1,0)
)
, adjustment_union as(
select * from reversals
union all
select * from original
union all
select * from adjustment
)

select * from adjustment_union
where claim_id not in (select claim_id from adjustment_union group by claim_id, line_no, adjustment_type having count(*) > 1)
