select 
	cast(e.member_id as varchar) as patient_id
    ,cast(d.member_gender_cd) as gender
    ,cast(d.member_dob as datetime) as birth_date
    ,cast(d.race_1_cd) as race
    ,cast(d.member_zip_cd as varchar) as zip_code
    ,cast(d.state_cd as varchar) as state
    ,cast(null) as deceased_flag
    ,cast(null as datetime) as death_date
    ,cast(d.payer_cd as varchar) as payer
    ,cast(e.line_of_business_cd as varchar) as payer_type
    ,cast(null as varchar) as dual_status
    ,cast(null as varchar) as medicare_status
    ,cast(e.eligibility_month as int) as month
    ,cast(e.eligibility_year as int) as year
from {{ var('member_eligibility')}} e
left join {{ var('member_demographics')}} d
	on b.member_id = sf.member_id