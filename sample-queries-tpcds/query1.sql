-- start query 1 in stream 0 using template query1.tpl and seed 2031708268
with customer_total_return as
(select sr_customer_sk as ctr_customer_sk
,sr_store_sk as ctr_store_sk
,sum(SR_FEE) as ctr_total_return
from store_returns
,date_dim
where sr_returned_date_sk = d_date_sk
and d_year =2000
group by sr_customer_sk
,sr_store_sk)
 select
        c_customer_id,
        elapsed_time_function(start_time, end_time) AS elapsed_time
from customer_total_return ctr1
,store
,customer
where ctr1.ctr_total_return > (select avg(ctr_total_return)*1.2
from customer_total_return ctr2
where ctr1.ctr_store_sk = ctr2.ctr_store_sk)
and s_store_sk = ctr1.ctr_store_sk
and s_state = 'NM'
and ctr1.ctr_customer_sk = c_customer_sk
order by c_customer_id
limit 100;

-- end query 1 in stream 0 using template query1.tpl


source query10.sql;
source query11.sql;
source query12.sql;
source query13.sql;
source query14.sql;
source query15.sql;
source query16.sql;
source query17.sql;
source query18.sql;
source query19.sql;
source query20.sql;
source query21.sql;
source query22.sql;
source query23.sql;
source query24.sql;
source query25.sql;
source query26.sql;
source query27.sql;
source query28.sql;
source query29.sql;

source query30.sql;
source query31.sql;
source query32.sql;
source query33.sql;
source query34.sql;
source query35.sql;
source query36.sql;
source query37.sql;
source query38.sql;
source query39.sql;
source query40.sql;
source query41.sql;
source query42.sql;
source query43.sql;
source query44.sql;
source query45.sql;
source query46.sql;
source query47.sql;
source query48.sql;
source query49.sql;
source query50.sql;
source query51.sql;
source query52.sql;
source query53.sql;
source query54.sql;
source query55.sql;
source query56.sql;
source query57.sql;
source query58.sql;
source query59.sql;
source query60.sql;
source query61.sql;
source query62.sql;
source query63.sql;
source query64.sql;
source query65.sql;
source query66.sql;
source query67.sql;
source query68.sql;
source query69.sql;
source query70.sql;
source query71.sql;
source query72.sql;
source query73.sql;
source query74.sql;
source query75.sql;
source query76.sql;
source query77.sql;
source query78.sql;
source query79.sql;
source query80.sql;
source query81.sql;
source query82.sql;
source query83.sql;
source query84.sql;
source query85.sql;
source query86.sql;
source query87.sql;
source query88.sql;


hive -e "source query88.sql;" > elapsed_time.txt

