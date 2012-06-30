#!/bin/sh


grep -B1 mysqld_port test_result_40-100.log | grep -v '\-\-' | sed -e 'N;s/\n/ /g' | awk '{ print $6, $7, $8, $5 }' | awk '{ if ($2 ~ /update/){print $1, $2, $3, $4*2; } else{ print $1, $2, $3, $4; } }'

