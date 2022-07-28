-------------------------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      July 2022
-- Purpose      Create list of all claims with duplicate claim lines.
-- Notes        
-------------------------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------------------------

with duplicate_claims as(
  select 
    l.claim_id
    , l.line_no
  from {{ var('medical_claims_header')}}  h
  inner join {{ var('medical_claims_line')}} l
    on l.claim_id = h.claim_id 
    and l.member_id = h.member_id
  group by l.claim_id, l.line_no
  having count(*) > 1
)

select distinct
  claim_id 
from duplicate_claims