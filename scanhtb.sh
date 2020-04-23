#!/usr/bin/env bash

## TODO
## add port 443 to scan
## add namp vuln scan

###################################################
#
# Script Name   : scanhtb.sh
# Description   : HTB VM PreEnum
# Author        : ITPPA (https://github.com/ITPPA)
# 
###################################################

GREEN='\e[32m'
LGREEN='\e[92m'
RED=`tput setaf 1`
YELLOW=`tput setaf 3`
BLUE='\e[94m'
CYAN='\e[36m'
RST=`tput sgr0`

# Print functions
function error {
	echo -e "[${RED}error${RST}] $@" 1>&2
	exit 1
}
function warning {
	echo -e "${RED}[!] $@ ${RST}" 1>&2
}
function result {
	echo -e "${LGREEN}[+] $@ ${RST}" 
}
function info {
	echo -e "${BLUE}[-] $@ ${RST}"
}
function command {
	echo -e "${BLUE}[+] ${GREEN}$@ ${RST}" 
}
function wait {
	echo -e "${YELLOW}[!] Please Wait... $@ ${RST}"
}
function barre {
	echo -e "${BLUE}[-] ----------------------- ${RST}"
}
function print_usage {
	cat <<EOF
Usage: $0 ip [OPTION]...

Initialize a new Hack the Box machine directory structure and perform initial scans.

Options:
	-h               display this help message
	-t               perform TCP scans (default)
	-u               perform UDP scans
Parameters:
	ip               Last digit of IP address (10.10.10.X)
EOF
}

# Some vars
IP="10.10.10.$1"
RUN_TCP=1
RUN_UDP=0
LISTE=("[y]es" "[n]o") 
PS3="[>] "
OCTET_REGEX='(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])'
IPV4_REGEX="^$OCTET_REGEX\.$OCTET_REGEX\.$OCTET_REGEX\.$OCTET_REGEX$"
DEFAULT_THREADS="10"
HTTP_REGEX='^.*80.*$'

while getopts ":htubk:n:i:" opt; do
	case ${opt} in
		t )
			RUN_TCP=1
			;;
		u )
			RUN_UDP=1
			;;
		h )
			print_usage
			exit 0
			;;
		\? )
			print_usage
			exit 1
			;;
	esac
done
shift $((OPTIND-1))

if [ "$#" -ne 1 ]; then
	error "error: no ip specified" >&2
	print_usage
	exit 1
fi

if ! [[ $IP =~ $IPV4_REGEX ]]; then
	error "$IP: expected an ipv4 address"
fi

info "Creation Rep ./scans if not exist"
[ ! -d ./scans ] && mkdir scans
barre
info "Start Full & Quick TCP Scan"
if [ -e scans/full.nmap ]; then
	info "[+] Check if file exist"
	command "ls -lh scans/full.nmap"
	result `ls -lh scans/full.nmap | awk '{$1=$2=$3=$4=""; print $0}'`
	warning "Full Scan File ./scans/full.nmap already exist, rescan?"
	select CHOIX in "${LISTE[@]}" ; do
	    case $REPLY in
	        1|y)
				command "nmap -p- --min-rate=1000 -Pn -T4 $IP -oN scans/full.nmap"
				wait "Full Scan proceeded"
				nmap -p- --min-rate=1000 -Pn -T4 $IP -oN scans/full.nmap 1>/dev/null
				break
				;;
			2|n)
		        break
		        ;;
	    esac
	done
else
	command "nmap -p- --min-rate=1000 -Pn -T4 $IP -oN scans/full.nmap"
	wait "Full Scan proceeded"
	nmap -p- --min-rate=1000 -Pn -T4 $IP -oN scans/full.nmap 1>/dev/null
fi
result "Full TCP Scan Saved in .scans/full.nmap"
ports=`grep "open" scans/full.nmap | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//` 
if [ -z "$ports" ]; then
	warning "no open tcp ports detected!"
	error "Exiting"
	exit 1
else
	result "Find Open Ports : $ports"
	barre
	info "Start Services Scan on TCP discovered port(s) : ${GREEN}$ports"
	if [ "$RUN_TCP" -eq "1" ]; then
	 	if [ -e "scans/nmap.xml" ]; then
	 		info "[+] Check if file exist"
			command "ls -lh scans/nmap.xml"
			result `ls -lh scans/nmap.xml | awk '{$1=$2=$3=$4=""; print $0}'`
			warning "Services Scan File scans/nmap.xml already exist, rescan?"
			select CHOIX in "${LISTE[@]}" ; do
			    case $REPLY in
			        1|y)
						command "nmap -sC -sV -p$ports $IP -oA ./scans/nmap"
						nmap -sC -sV -p$ports $IP -oA ./scans/nmap
						break
						;;
					2|n)
				        break
				        ;;
			    esac
			done
	 	else	
			command "nmap -sC -sV -p$ports $IP -oA ./scans/nmap"
			nmap -sC -sV -p$ports $IP -oA ./scans/nmap
		fi
		result "TCP Services Scan Saved in .scans/nmap.*"
	fi
	# run udp scan
	if [ "$RUN_UDP" -eq "1" ] && ! [ -f "scans/udp.out" ]; then
		info "Start UDP Scan"
		command "nmap -sU $1 -vv -oN scans/udp.out"
		nmap -sU $IP -vv -oN scans/udp.xml
		info "Scan UDP Save As ./scans/udp.out"
	fi
fi

#ports="22,80"
# run gobuster if p 80 
barre
info "Check Web Services"


if [[ $ports =~ $HTTP_REGEX ]] || [ $ports = "80" ]; then
	result "Find Port 80 Open, scan?"
	select CHOIX in "${LISTE[@]}" ; do
	    case $REPLY in
	        1|y)
			select scanner in Gobuster Dirb ; do
				case $scanner in
					Gobuster)
						read -p "Nombre de threads [default 10] : " threads
						threads=${threads:-$DEFAULT_THREADS}
						info "Run Gobuster"
						command "gobuster dir --url=http://$IP/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t $treads -o scans/gobuster-main.txt -x .php,.html,.txt"
		        		wait "Gobuster Running"
		        		gobuster dir --url=http://$IP/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt \
		        		 -a "Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0" \
		        		 -t $threads \
		        		 -o scans/gobuster-main.txt \
		        		 -x .php,.html,.txt -q
		        		break
		        		;;
	        		Dirb)
						info "Run Dirb"
						command "dirb http://$IP/ /usr/share/dirb/wordlists/common.txt -o scans/dirbuster-main.txt"
						wait "Dirb Running"
						dirb http://$IP/ /usr/share/dirb/wordlists/common.txt \
						-a "Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0" \
						-o scans/dirbuster-main.txt
					break
					;;
				esac
				done
				break
				;;
	        2|n)
	        break
	        ;;
	    esac
	done
fi
info "Cleanup Files"
#rm scans/full.nmap

#todo : put all in one file
result "Script End, Happy Hacking"