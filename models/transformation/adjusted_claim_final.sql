-------------------------------------------------------------------------------
-- Author       Thu Xuan Vu
-- Created      July 2022
-- Purpose      Create a distinct list of adjusted and reversed claims.
-- Notes        The extraction of reversed claims can be kept or removed based
--                  on an organization's needs.
-------------------------------------------------------------------------------
-- Modification History
--
-------------------------------------------------------------------------------

select
    s.*
from {{ ref('adjusted_claim_stage')}} s
inner join {{ ref('adjusted_claim_validation')}} v
    on s.claim_id = v.claim_id
where adjustment_type = 'A'

union all

select 
    s.*
from {{ ref('adjusted_claim_stage')}} s
inner join {{ ref('adjusted_claim_validation')}} v
    on s.claim_id = v.claim_id
where adjustment_type = 'R'
and s.claim_id not in (select s.claim_id from {{ ref('adjusted_claim_stage')}} s 
                                        inner join {{ ref('adjusted_claim_validation')}} v
                                        on s.claim_id = v.claim_id 
                                        where adjustment_type = 'A')
