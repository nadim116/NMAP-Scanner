#!/bin/bash

#add color variable for text
RD='\033[00;31m'
GR='\033[00;32m'
CY='\033[00;36m'
RESTORE='\033[0m\n'

function printUsage() {
    printf "${GR}Usage: $0 ${CY}[-p <Product>] ${CY}[-i <IP>] ${CY}[-h <Hostname>] ${RESTORE}"
}

#Shows Usage
if [ $# -eq 0 ]; then
	printUsage
	exit 1
fi

#Assigns option to the variable
while [ $1 ]; do
    case $1 in
        -p)
            shift
            PRODUCT=$1
            ;;
        -i)
            shift
            IP=$1
            ;;
        -h)
            shift
            HOSTNAME=$1
            ;;
        *)
            printf "${RD}Incorrect Option: $1 ${RESTORE}"
            echo
            printUsage
            exit 1
            ;;
    esac
    shift
done

while [ $2 ]; do
    case $1 in
        -p)
            shift
            PRODUCT=$2
            ;;
        -i)
            shift
            IP=$2
            ;;
        -h)
            shift
            HOSTNAME=$2
            ;;
        *)
            printf "${RD}Incorrect Option: $2${RESTORE}"
            echo
            printUsage
            exit 1
            ;;
    esac
    shift
done

# check IPv4 or Hostname

if [[ "$IP" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    ADDRESS=$IP
    echo -en ${GR}'Valid IP - Starting Scan Now'${RESTORE}
 elif  [[ "$HOSTNAME" == *cst.crp ]] ; then
    printf "Hostname is:${GR} $HOSTNAME ${RESTORE}"
    HIP=$(ping -c1 $HOSTNAME | sed -nE 's/^PING[^(]+\(([^)]+)\).*/\1/p')
    printf "IP is:${GR} $HIP ${RESTORE}"
    ADDRESS=$HIP
else
    echo -en ${RD}"Invalid IP or Hostname" ${RESTORE}>&2
    exit 1
fi

#Checks what product has been defined and checks if our required ports are opened or filtered
if [[ $PRODUCT =~ [Aa][Tt][Ll][Aa][Ss] ]]; then
	sudo nmap -p 4377,5222,7443,8881,443,5900,4311,4312,4313,4314,4315,4316,4317,4318,4319 $ADDRESS
elif  [[ $PRODUCT =~ [Ss][Tt][Bb][Tt][Pp] ]]; then
	sudo nmap -p 8443,443,8881,5900,4322,4310,4311 $ADDRESS
elif  [[ $PRODUCT =~ [Cc][Mm][Tt][Pp] ]]; then
	sudo nmap -p 4322,7443,8881,443,5900 $ADDRESS
else
    printf "${RD}No Product Found!${RESTORE}"
fi
