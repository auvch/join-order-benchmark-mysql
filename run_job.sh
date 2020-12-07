#!/usr/bin/env bash
# run_job.sh  selected.txt  queries_dir   output

avg_lat=0
avg_tps=0
count=0

while read a ; do
  tmp=$(mysql -uroot -S$MYSQL_SOCK imdbload < $2/$a | tail -n 1 )
  query=`echo $tmp | awk '{print $1}'`
  lat=`echo $tmp | awk '{print $2}'`
  
  echo $lat

  avg_lat=$(echo "$avg_lat + $lat / 1000" | bc)
  avg_tps=$(echo "$avg_tps + 60000 / $lat" | bc)
  ((count += 1))

done < $1

((avg_lat /= count))
((avg_tps /= count))

printf "avg_tps(txn/min): \t%5.2f\navg_lat(ms): \t%5.2f" $avg_tps $avg_lat > $3
