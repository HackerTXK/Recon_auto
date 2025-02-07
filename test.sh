#!/bin/bash


cat domains.txt | while read url; do
    sublist3r 1>/dev/null -d "$url" -o tmp.txt && cat tmp.txt >> 3sub.txt
    #echo "$url";
done


