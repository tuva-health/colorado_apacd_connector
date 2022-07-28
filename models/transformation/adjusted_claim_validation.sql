-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      July 2022
-- Purpose      Create a list of distinct claims.  Using the sum of claim line 
--                payments and the claim header to validate the correct claim lines
--                were identified/logic in prior step is working correctly
-- Notes        Have confirmed that a properly adjusted claim does not
--                always equal the header. (Reviewed the logic and math manually)
--                However it felt like a good validation step and omits 18% claims
--                (from the adjustment population).  Can be removed at an organization's discretion.
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------


with total_payments as(
  select s.claim_id
  , sum(s.plan_paid_amt) as adjusted_payment_total
  , max(h.plan_paid_amt) as header_total
  from {{ ref('adjusted_claim_stage')}} s
  inner join {{ var('medical_claims_header')}} h
    on s.claim_id = h.claim_id
  group by s.claim_id
)

select * from total_payments t
where adjusted_payment_total = header_total