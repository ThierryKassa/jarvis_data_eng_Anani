#!/bin/bash

#hostname=$(hostname -f)
lscpu_out=`lscpu`
#vmstat_out=`vmstat --unit M`

echo Hardware info
  hostname=$(hostname -f)
		echo "hostname= $hostname"
  cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)

		echo "cpu_number= $cpu_number"
  cpu_architecture=$(echo "$lscpu_out"  | egrep "Architecture" | awk '{print $2}' | xargs)
		echo "cpu_architecture= $cpu_architecture"
  cpu_model=$(echo "$lscpu_out"  | egrep "Model" | awk '{print $3,$4,$5,$6,$7}' | xargs)
		echo "cpu_model= $cpu_model"
  cpu_mhz=$(echo "$lscpu_out"  | egrep -i "^cpu mhz" | awk '{print $3}' | xargs)
		echo "cpu_mhz= $cpu_mhz"
  l2_cache=$(echo "$lscpu_out"  | egrep -i "^l2 cache" | awk '{print $3}' | xargs)
	echo "l2_cache= $l2_cache"

  total_mem=$(vmstat --unit M | tail -1  | awk '{print $4}')
	echo "total_mem= $total_mem"

  timestamp=$(vmstat -t | tail -1 | awk '{print $18,$19}')
	echo "timestamp= $timestamp"	
