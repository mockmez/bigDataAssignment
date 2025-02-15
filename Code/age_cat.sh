#!/bin/bash

out=age-cat-$1
# bash fixdata.sh $1

count=0
while IFS="\n" read -r line; do
    if [[ $count -eq 0 ]]; then
        echo $line > $out
    else
        line_head=`echo $line | cut -d',' -f1-2`
        age=`echo $line | cut -d',' -f3 | cut -d'.' -f1`
        if [[ "$age" =~ ^[0-9]+$ ]]; then
            ((lower=age/10*10))
            ((upper=age/10*10+10))
            echo "$line_head,\"$lower - $upper\"" >> $out
            echo $count
        fi
    fi
    ((count=count+1))
done < "clean-$1"

# rm "clean-$1"