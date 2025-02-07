#!/bin/bash

#echo "Creating directory $1_recon. Let's go!"
#today=$(date)
#echo "This is scan was created on $today"


# echo help
# if [$domain == "-h"]
# then
# echo "enter ./recon.sh tool_name to use"
# Select which tool to run
# echo "this is test"
#test comment
    
source ./scan.lib
getopts "m:" OPTION
mode=$OPTARG
# $OPTIND parses argument after first options
# $# the number of command line arguments 
# @ array  containing all input arguments
for i in "${@:$OPTIND:$#}" # here, also $#-1  $#+1
do 
    domain=$i
    directory=${domain}_recon
    echo "Creating directory $directory."
    mkdir $directory
    case $mode in
        nmap_only)
            nmap_scan
            ;;
        dirsearch_only)
            dirsearch_scan
            ;;
        sub_only)
            sub_scan
            ;;
        crt_only)
            crt_scan
            ;;
        *)
            nmap_scan
            dirsearch_scan
            sub_scan
            crt_scan
            ;; 
    esac

    echo "Generating recon report from output files..."
    
    echo "This scan was created on $today" > $directory/report.txt
    if [ -f $directory/nmap ] 
    then 
        echo "Results for nmap:" >> $directory/report.txt
        grep -E "^\s*\S+\s+\S+\s+\s*$" $directory/nmap.txt >> $directory/report.txt
    fi

    if [ -f $directory/dirsearch.txt ]
    then
        echo "Results for Dirsearch:" >> $dirsearch/report.txt
        cat $directory/dirsearch.txt >> $directory/report.txt
    fi

    if [ -f $directory/sub_all.txt ]
    then
        echo "Results for subdomain" >> $directory/report.txt
        cat $directory/sub_all.txt >> $directory/report.txt
    fi
done