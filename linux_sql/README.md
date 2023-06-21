# Introduction
The present project named Linux Cluster Monitoring Agent (LCMA) aimed to manage a Linux cluster of 10 nodes/servers running CentOS 7 used by the Jarvis Linux Cluster Administration (LCA). These servers are internally connected through a switch and able to communicate through internal IPv4 addresses. The functionnality of the project is to record the hardware specifications of each node and monitor node resource usage (e.g. CPU, memory) in real-time. The collected data is stored in an RDBMS. The LCA team will use the data to generate reports for future resource planning purposes (e.g. add or remove servers).

The solution proposed is made of four scripts files details in the quick start section using the following technology: Docker (container, images, volume), RDBMS(psql), Git(add, commit, push, PR) and Linux (bash scripts, regexp, crontab).

# Quick Start
- Start a psql instance using psql_docker.sh
- Create tables using ddl.sql
- Insert hardware specs data into the DB using host_info.sh
- Insert hardware usage data into the DB using host_usage.sh
- Crontab setup

# Implementation
To implement the project, I first used Intellij IDEA as IDE for code writting. This IDE is a great combinaison of terminal and GUI, respectively for linux command execution and code view and file organization.
Second, I install Docker to be able to create a container that hold the project for deployment purpose and create a volume to persist data, which serve as a hub for the RDBMS database.


## Architecture
Consult the cluster diagram with three Linux hosts, a DB, and agents in the `assets` directory.

## Scripts
- psql_docker.sh: check if the container jrvs-psql exist and create one otherwise, displays as follows:

        "HostConfig": {
            "Binds": [
                "pgdata:/var/lib/postgresql/data"
            ],
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {
                "5432/tcp": [
                    {
                        "HostIp": "",
                        "HostPort": "5432"
                    }
                ]}}

- host_info.sh : retrieve the nodes technical specifications and insert to the host_info table in the database, displays as follows:

> hostname=spry-framework-236416.internal   
> cpu_number=1 
> cpu_architecture=x86_64
> cpu_model=Intel(R) Xeon(R) CPU @ 2.30GHz  
> cpu_mhz=2300.000  
> L2_cache=256       
> total_mem=601324  
> timestamp=2019-05-29 17:49:53  

- host_usage.sh: retrieve the nodes CPU technical specifications and insert to the host_usage table in the database, displays as follows:

> timestamp=2019-05-29 16:53:28
> host_id=1                  
> memory_free= 256             
> cpu_idle=95                 
> cpu_kernel=0                 
> disk_io=0                    
> disk_available=31220

- crontab: collect data point every minute automatically so that we can collect one data point per minute
- queries.sql: displays the information contains in the database in more structured data. It helps the LCA team to use the data to generate reports for future resource planning purposes (e.g. add or remove servers).

## Database Modeling
- `host_info`: collects the host hardware info and insert it into the database. It will be run only once at the installation time.

> id |   hostname           | cpu_num | cpu_arch |  cpu_model | cpu_mhz  | l2_cache |  timestamp | total_mem  

> 1  | jrvs-remote-desk.... |  	    2 |  x86_64  | Intel(R)...| 2299.998 | 	    256 |2023-06-19..|      2634


- `host_usage`: collects the current host usage (CPU and Memory) and then insert into the database. It will be triggered by the cron job every minute.

> timestamp           | host_id | memory_free | cpu_idle | cpu_kernel | disk_io | disk_available  

> 2023-06-19 05:52:18 |       1 |        2651 |       97 |          1 |       0 |          22834  
> 2023-06-19 15:24:01 |       1 |        2643 |       97 |          0 |       0 |          22828  
> 2023-06-19 15:25:01 |       1 |        2643 |       97 |          0 |       0 |          22828  
> 2023-06-19 15:26:01 |       1 |        2641 |       97 |          0 |       0 |          22828  
> 2023-06-19 15:27:01 |       1 |        2640 |       97 |          0 |       0 |          22828  


# Test
The program is tested by running both the ddl.sql and queries.sql. By running the ddl.sql, we connect to the database host_agent, and checkout it the table host_info and host_usage are created or create them otherwise. The queries.sql displays the data recorded in each tables and
more.

# Deployment
The deployment of the app is made through docker, which host the app with the container jrvs-psql and keep recorded the node data usage info through the RDBMS postgresql created through the public hub instance pgdata volume.
The recorded node data usage is made through an automatic process by setting up the crontab. it executes the host_usage.sh file every minutes and save those data in the host_usage table inside the database.
The code and scripts are made available on Github through the version control file system process which use Git.

# Improvements
- handle hardware updates
- extend the app functionality to collect more consistent data volume
- set a function to trigger the crontab to keep only daily information in the database.