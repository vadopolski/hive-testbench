## Build and configure a test cluster

Generate and load data:
1. Using Putty with key and host name from chat, with login: hadoop  connect to the server.
2. Try to open YARN UI in FireFox browser: http://172.31.41.127:8088/cluster
3. Enter to the directory  testing/hive-testbench
4. Create a directory for the data on hdfs dfs -mkdir /user/yourname/
5. Run the script to generate the semi-structured data ./tpcds-setup.sh 20 /user/yourname/
6. Check the YARN UI to see the progress of the job
7. CHeck the generated data on hdfs dfs -ls /user/yourname/20/
8. Go to the directory with the queries: cd ddl-tpcds/text/
9. Go to the Hive cli: hive and run the following commands:
   1. set hivevar:DB = yourname_bronze_layer;
   2. set hivevar:LOCATION = /user/yourname/20/;
   3. source alltables.sql;
   4. source analyze_everything.sql;
   5. show tables;
   6. desc any_table_name;
   7. select * from any_table_name limit 10 or 
   8. select count(*) from any_table_name;

10. Run the queries to build a silver layer:

## Write/modify and deploy applications/scripts on test servers:
1. Go to the directory with the scripts: cd testing/hive-testbench/sample-queries-tpcds
2. Read the script in the editor: cat query55.sql
3. Invoke the Hive scripts and check the time the Hive CLI: hive
   1. use yourname_bronze_layer;
   2. source query55.sql;
4. Check the YARN UI to see the progress of the job
5. Check the time of the job in the Hive CLI

## Prepare and deploy workflow scripts:
1. Login to the HUE UI: http://http://172.31.41.127:8888/ with login: admin and password: !QAz3edc
2. Upload process scripts to the HDFS with command: 
   $shell
    ```` hdfs dfs -mkdir /user/opolski/deploy/
    ```` hdfs dfs -put /home/hadoop/testing/hive-testbench/sample-queries-tpcds/01_process.sql /user/opolski/deploy
3. Create a new workflow: Scheduler -> Workflow 
4. Switch to actions tab and create a new Workflow: 
   1. Name: any_with_your_name
   2. Description: any_description
   3. Type: Hive
   4. Script: select * from yourname_bronze_layer.store_sales limit 10;
   5. Save

Develop and upload source data:
  


