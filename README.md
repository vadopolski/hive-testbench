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
  




hive-testbench
==============

A testbench for experimenting with Apache Hive at any data scale.

Overview
========

The hive-testbench is a data generator and set of queries that lets you experiment with Apache Hive at scale. The testbench allows you to experience base Hive performance on large datasets, and gives an easy way to see the impact of Hive tuning parameters and advanced settings.

Prerequisites
=============

You will need:
* Hadoop 2.2 or later cluster or Sandbox.
* Apache Hive.
* Between 15 minutes and 2 days to generate data (depending on the Scale Factor you choose and available hardware).
* If you plan to generate 1TB or more of data, using Apache Hive 13+ to generate the data is STRONGLY suggested.

Install and Setup
=================

All of these steps should be carried out on your Hadoop cluster.

- Step 1: Prepare your environment.

  In addition to Hadoop and Hive, before you begin ensure ```gcc``` is installed and available on your system path. If you system does not have it, install it using yum or apt-get.

- Step 2: Decide which test suite(s) you want to use.

  hive-testbench comes with data generators and sample queries based on both the TPC-DS and TPC-H benchmarks. You can choose to use either or both of these benchmarks for experiementation. More information about these benchmarks can be found at the Transaction Processing Council homepage.

- Step 3: Compile and package the appropriate data generator.

  For TPC-DS, ```./tpcds-build.sh``` downloads, compiles and packages the TPC-DS data generator.
  For TPC-H, ```./tpch-build.sh``` downloads, compiles and packages the TPC-H data generator.

- Step 4: Decide how much data you want to generate.

  You need to decide on a "Scale Factor" which represents how much data you will generate. Scale Factor roughly translates to gigabytes, so a Scale Factor of 100 is about 100 gigabytes and one terabyte is Scale Factor 1000. Decide how much data you want and keep it in mind for the next step. If you have a cluster of 4-10 nodes or just want to experiment at a smaller scale, scale 1000 (1 TB) of data is a good starting point. If you have a large cluster, you may want to choose Scale 10000 (10 TB) or more. The notion of scale factor is similar between TPC-DS and TPC-H.

  If you want to generate a large amount of data, you should use Hive 13 or later. Hive 13 introduced an optimization that allows far more scalable data partitioning. Hive 12 and lower will likely crash if you generate more than a few hundred GB of data and tuning around the problem is difficult. You can generate text or RCFile data in Hive 13 and use it in multiple versions of Hive.

- Step 5: Generate and load the data.

  The scripts ```tpcds-setup.sh``` and ```tpch-setup.sh``` generate and load data for TPC-DS and TPC-H, respectively. General usage is ```tpcds-setup.sh scale_factor [directory]``` or ```tpch-setup.sh scale_factor [directory]```

  Some examples:

  Build 1 TB of TPC-DS data: ```./tpcds-setup.sh 1000```

  Build 1 TB of TPC-H data: ```./tpch-setup.sh 1000```

  Build 100 TB of TPC-DS data: ```./tpcds-setup.sh 100000```

  Build 30 TB of text formatted TPC-DS data: ```FORMAT=textfile ./tpcds-setup 30000```

  Build 30 TB of RCFile formatted TPC-DS data: ```FORMAT=rcfile ./tpcds-setup 30000```

  Also check other parameters in setup scripts important one is BUCKET_DATA.

- Step 6: Run queries.

  More than 50 sample TPC-DS queries and all TPC-H queries are included for you to try. You can use ```hive```, ```beeline``` or the SQL tool of your choice. The testbench also includes a set of suggested settings.

  This example assumes you have generated 1 TB of TPC-DS data during Step 5:

  	```
  	cd sample-queries-tpcds
  	hive -i testbench.settings
  	hive> use tpcds_bin_partitioned_orc_1000;
  	hive> source query55.sql;
  	```

  Note that the database is named based on the Data Scale chosen in step 3. At Data Scale 10000, your database will be named tpcds_bin_partitioned_orc_10000. At Data Scale 1000 it would be named tpch_flat_orc_1000. You can always ```show databases``` to get a list of available databases.

  Similarly, if you generated 1 TB of TPC-H data during Step 5:

  	```
  	cd sample-queries-tpch
  	hive -i testbench.settings
  	hive> use tpch_flat_orc_1000;
  	hive> source tpch_query1.sql;
  	```

Feedback
========

If you have questions, comments or problems, visit the [Hortonworks Hive forum](http://hortonworks.com/community/forums/forum/hive/).

If you have improvements, pull requests are accepted.
