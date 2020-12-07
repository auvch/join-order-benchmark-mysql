# join-order-benchmark-mysql
join-order-benchmark for mysql

# Prepare data
download data files from http://homepages.cwi.nl/~boncz/job/imdb.tgz; then extract
```
mkdir job; cd job;
mkdir imdb-2014-csv-mysql
tar zxvf imdb.tgz 
mv *.csv imdb-2014-csv-mysql
```

# Load data
add a new line `sql_mode=NO_ENGINE_SUBSTITUTION` to `my.cnf` or `my.ini`, and restart mysqld

then run the followings:
```
mysql -uroot -S$MYSQL_SOCK -e "drop database if exists imdbload"
mysql -uroot -S$MYSQL_SOCK -e "create database imdbload"
mysql -uroot -S$MYSQL_SOCK  imdbload < schema.sql

cat table_list.txt | while read a ; do 
echo "LOAD DATA INFILE '`pwd`/imdb-2014-csv-mysql/$a.csv' INTO TABLE $a FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';"
done > load-data.sql

mysql -uroot -S$MYSQL_SOCK imdbload < load-data.sql
mysql -uroot -S$MYSQL_SOCK imdbload < fkindexes.sql

cat table_list.txt | while read a ; do 
  echo "analyze table $a;"
done > analyze-tables.sql

mysql -uroot -S$MYSQL_SOCK imdbload < analyze-tables.sql
```

# Generate workload
Generate workload of all 113 queries:
```
(

cat db_init.sql

for FILE in queries-mysql/[0-9]*.sql ; do 

  QUERY_NAME=`basename $FILE`
  QUERY_NAME=${QUERY_NAME/.sql/}

  echo "-- ### QUERY $QUERY_NAME ##########################################"

  echo "-- ### Test run "
  sed -e "s/__QUERY_NAME__/$QUERY_NAME/" < query_start.sql
  cat $FILE

  cat query_end.sql
done

) > run-all-queries.sql
```

Or you can specify a list of queries in `selected.txt` and generate workload partly:
```
(

cat db_init.sql

cat selected.txt | while read a ; do 

  QUERY_NAME=${a/.sql/}

  echo "-- ### QUERY $QUERY_NAME ##########################################"

  echo "-- ### Test run "
  sed -e "s/__QUERY_NAME__/$QUERY_NAME/" < query_start.sql
  cat queries-mysql/$a
  # cat $FILE

  cat query_end.sql
done

) > run-selected-queries.sql
```

# Run workload
```
mysql -uroot -S$MYSQL_SOCK imdbload < run-all-queries.sql | tee test-workload/log.txt
```
it can be also executed without output:
```
mysql -uroot -S$MYSQL_SOCK imdbload < run-all-queries.sql > /dev/null 2>&1
```
To export execution time:
```
select query_name, query_time_ms from my_job_result into outfile 'output.csv';
```
