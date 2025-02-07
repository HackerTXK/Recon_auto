#!/bin/bash

SECONDS=0
purple='\033[0;35m'
blue='\033[0;34m'
nc='\033[0m'
b_IYellow='\033[0;103m'
BPurple='\033[1;35m'


figlet "Recon is key" -f smslant | lolcat -p 0.5
printf "\n"
printf "===========STAGE 1, passive enumeration subdomain============================================\n\n"
# mkdir 1-passive-sub
# #subfinder
# printf "${blue}Passive step 1, subfinder...${nc}\n"
# subfinder -silent -dL domains.txt > 1-passive-sub/1sub.txt   #can use -all flag, use all source enum
# printf "${purple}subfinder completed!${nc}\n\n"

# #amass
# printf "${blue}Passive step 2, amass...${nc}\n"
# amass enum -silent -passive -norecursive -df domains.txt -o 1-passive-sub/2sub.txt
# printf "${purple}amass completed!${nc}\n\n"

# #sublist3r
# printf "${blue}Passive step 3, subllist3r...${nc}\n"
# cat domains.txt | while read url; do
#    sublist3r.py 1>/dev/null -d "$url" -o tmp.txt && cat tmp.txt >> 1-passive-sub/3sub.txt
#     echo "$url";
# done
# printf "${purple}sublist3r completed!${nc}\n\n"

# #merge all passive subdomians...
# printf "${blue}Remove all duplicate, merge all passive subdomians...${nc}\n"
# sort -u 1-passive-sub/1sub.txt 1-passive-sub/2sub.txt 1-passive-sub/3sub.txt -o 1-passive-sub/all-passive.txt 1>/dev/null
# printf "${purple}Merge all passive completed!${nc}\n\n"

# #alterx
# printf "${blue}alterx more subdomains...${nc}\n"
# alterx -l 1-passive-sub/all-passive.txt -o 1-passive-sub/alterx-all-passive.txt -silent
# printf "${purple}alterx passive subdomains completed!${nc}\n\n"

# #puredns resolve passive's alterx
# printf "${blue}puredns resolve passive's alterx...${nc}\n" 
# puredns resolve -l 3000 -t 50 1-passive-sub/alterx-all-passive.txt -r ~/tool/resolvers/resolvers-trusted.txt -w 1-passive-sub/puredns-alterx-all-passive.txt --wildcard-batch 1000000 -q
# printf "${purple}puredns resove passive's alterx completed!${nc}\n\n"

# #add puredns-alterx-all-passive.txt to all-passive.txt
# printf "${blue}Add puredns-alterx-all-passive.txt to all-passive.txt...${nc}\n"
# sort -u 1-passive-sub/puredns-alterx-all-passive.txt 1-passive-sub/all-passive.txt -o 1-passive-sub/most-all-passive.txt 1>/dev/null
# printf "${purple}Add puredns-alterx-all-passive.txt to all-passive.txt completed!${nc}\n\n"

# printf "${BPurple}Passive enumeration subdomains completed!${nc}\n\n"


# STAGE 2, active enumeration subdomains
printf "===========STAGE 2, active enumeration subdomains============================================\n\n"
mkdir 2-active-sub

#puredns bruteforce
printf "${blue}puredns bruteforce...${nc}\n"
puredns bruteforce -l 3000 -t 50 ~/Desktop/google_drive/qed_fuzz/subdomains/best-dns-wordlist.txt -d domains.txt -r ~/tool/resolvers/resolvers-trusted.txt -w 2-active-sub/bruteforce-dns-sub.txt --wildcard-batch 1000000 #-q
printf "${purple}puredns bruteforce completed!${nc}\n\n"

#alterx
printf "${blue}alterx more subdomains...${nc}\n"
alterx -l 2-active-sub/bruteforce-dns-sub.txt -o 2-active-sub/alterx-all-active.txt -silent
printf "${purple}alterx active subdomains completed!${nc}\n\n"

#puredns resolve active's alterx
printf "${blue}puredns resolve active's alterx...${nc}\n" 
puredns resolve -l 3000 -t 50 2-active-sub/alterx-all-active.txt -r ~/tool/resolvers/resolvers-trusted.txt -w 2-active-sub/puredns-alterx-all-active.txt --wildcard-batch 1000000 -q
printf "${purple}puredns resove active's alterx completed!${nc}\n\n"

#add puredns-alterx-all-active.txt to bruteforce-dns-sub.txt
printf "${blue}Add puredns-alterx-all-active.txt to bruteforce-dns-sub.txt...${nc}\n"
sort -u 2-active-sub/puredns-alterx-all-active.txt 2-active-sub/bruteforce-dns-sub.txt -o 2-active-sub/most-all-active.txt 1>/dev/null
printf "${purple}Add puredns-alterx-all-active.txt to bruteforce-dns-sub.txt completed!${nc}\n\n"

printf "${BPurple}Active enumeration subdomains completed!${nc}\n\n"



#STAGE 3, merge most-all passive subdomains and most-all active subdomains.txt
printf "===========STAGE 3, Merge most-all passive subdomains and most-all active subdomains=========\n\n"

printf "${blue}Merge most-all passive subdomains and most-all active subdomains...${nc}\n"
sort -u 1-passive-sub/most-all-passive.txt 2-active-sub/most-all-active.txt -o most-all-subdomains.txt
printf "${purple}Merge most-all passive subdomains and most-all active subdomains completed!${nc}\n\n"

elapsed_time=$SECONDS
printf "${BPurple}Subdomain enumeration finished, named most-all-subdomains.txt, cost TIME is $elapsed_time seconds${nc}\n\n"


printf "===========STAGE 4, Probe live subdomsins====================================================\n\n"
mkdir 3-live-sub
# httpx
printf "${blue}Probe live subdomsins...${nc}\n"
httpx -l most-all-subdomains.txt -sc -cl -title -td -nc -silent -rl 80 -t 20 -o 3-live-sub/live-most-all-subdomains.txt
printf "${purple}Probe live subdomsins completed!...${nc}\n\n"

# classify
printf "${blue}classify...${nc}\n"
grep 200 live-sub/live-most-all-subdomains.txt > 200-sub.txt
grep -E "301|302|304" live-sub/live-most-all-subdomains.txt > live-sub/3begin-sub.txt
grep -E "403|401|400" live-sub/live-most-all-subdomains.txt > live-sub/4begin-sub.txt
grep -E "500|501|502|503|504" live-sub/live-most-all-subdomains.txt > live-sub/5begin-sub.txt
printf "${purple}classify completed!...${nc}\n\n"


printf "${BPurple}live subdomain probe completed!${nc}\n\n"


printf "==========STAGE 5, Port scan=================================================================\n\n"
# printf "\n"
printf "May be take long time, patience!\n\n"
mkdir 4-portscan
printf "${blue}nmap scan all port, exclude 80 and 443...${nc}\n"
# nmap -sV -iL most-all-subdomains.txt -oN 4-portscan/scaned-port.txt --script vuln --exclude-ports 80,443 -p-
printf "${purple}nmap scan completed!${nc}\n\n"






















