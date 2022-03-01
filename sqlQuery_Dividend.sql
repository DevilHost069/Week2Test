  with tmp_record as  
     (select company, fiscal_year 
              , lead( fiscal_year,1) over( partition by company order by fiscal_year) as fy1
              , lead( fiscal_year,2) over( partition by company order by fiscal_year) as fy2              
           from dividend)
  
  select array_to_json(array_agg(row_to_json(jsonfmt)))
    from  ( select distinct on (company) company as valuestocks
				  from tmp_record
				  where fiscal_year/10000 = fy1/10000 - 1
				  and   fiscal_year/10000 = fy2/10000 - 2
				  order by company) jsonfmt