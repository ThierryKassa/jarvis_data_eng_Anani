#!/bin/bash


echo "CPU usage info"

memory_free=$(vmstat --unit M | tail -1 | awk -v col="4" '{print $col}')
echo "memory_free= $memory_free"

cpu_idle=$(vmstat --unit M | tail -1 | awk -v col="15" '{print $col}')
echo "cpu_idle= $cpu_idle"

cpu_kernel=$(top -bn1| egrep -i "^\%cpu\(s\):" | awk '{print $8,$9}')
echo "cpu_kernel= $cpu_kernel"

disk_io=$(vmstat --unit M -d | tail -1 | awk -v col="11" '{print $col}')
echo "disk_io= $disk_io"

disk_available=$(df -BM / | tail -1 | awk -v col="4" '{print $col}')
echo "disk_available= $disk_available"
