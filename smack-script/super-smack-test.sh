#!/bin/sh
sk1=select-key_1000000.smack
sk2=select-key_10000000.smack
sk3=select-key_100000000.smack

ska3=select-key-alter_100000000.smack
ska2=select-key-alter_10000000.smack
ska1=select-key-alter_1000000.smack

usi3=update-select-inplace_100000000.smack
usi2=update-select-inplace_10000000.smack
usi1=update-select-inplace_1000000.smack

usia3=update-select-inplace-alter_100000000.smack
usia2=update-select-inplace-alter_10000000.smack
usia1=update-select-inplace-alter_1000000.smack

usni3=update-select-not-inplace_100000000.smack
usni2=update-select-not-inplace_10000000.smack
usni1=update-select-not-inplace_1000000.smack

usnia3=update-select-not-inplace-alter_100000000.smack
usnia2=update-select-not-inplace-alter_10000000.smack
usnia1=update-select-not-inplace-alter_1000000.smack

smack=/usr/local/super-smack-1.3/bin/super-smack
#smack=echo
total_run_count=1000000;
min_run_count=100000;

port_arr=( 3306 3307 3308);
con_arr=( 5 10 20 30 40 50 60 70 80 90 100);
row_arr=( 1000000 10000000 100000000 );

test_name_arr=( "select-key" "update-select-inplace" "update-select-not-inplace" );

 
for ((j=0; j<${#con_arr[@]};j++))
do
  concurrency=${con_arr[$j]};

  for((i=0; i<${#test_name_arr[@]};i++))
  do
    test_name=${test_name_arr[$i]};
    
    for ((m=0; m<${#row_arr[@]};m++))
    do
      row_count=${row_arr[$m]};
  
      for ((k=0; k<${#port_arr[@]};k++))
      do
        port=${port_arr[$k]};
    
        run_count=`expr ${total_run_count} / ${concurrency}`;
  
        #if [ $concurrency -eq 5 ]
        #then
          #if [ $port -eq 3306 -o $port -eq 3307 ]
  	      #then
  	        #echo $port 5;
            #continue;
          #fi
        #fi
  
        if [ ${run_count} -lt  $min_run_count ]
        then
          run_count=$min_run_count;
        fi
        
        date && ${smack} --port=${port} ${test_name}_${row_count}.smack ${concurrency} ${run_count};
        #echo update_index	1000000	0	0	10675.91
        echo mysqld_port=${port} ${test_name}_${row_count}.smack ${concurrency} ${run_count};
        echo ..;
        echo ..;
        sleep 30;
  
        if [ $port -eq 3307 ]
        then
          date && ${smack} --port=3306 ${test_name}-alter_${row_count}.smack ${concurrency} ${run_count};
          #echo update_index	1000000	0	0	10675.91
          echo mysqld_port=3306 ${test_name}-alter_${row_count}.smack ${concurrency} ${run_count} completed;
          echo ..;
          echo ..;
          sleep 30;
        fi
      done
    done
  done 
done

