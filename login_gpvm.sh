#!/bin/bash
#################################################################
# A quick shell script to login to MINERvA GPVM machine
# Nuruzzaman <nur@fnal.gov>, Date Created: 03/08/2018
#
# Last modified: 03/15/2018
#################################################################

# Define color and theme for terminal
black='\033[30m'
red='\033[31m'
blue='\033[34m'
bold='\033[1m'
normal='\033[0m'
EXPERT='Nuruzzaman <nur@fnal.gov>'

USER_INFO=${1:-$USER}

declare -a GPVM_ARRAY=( "01" "02" "03" "04" "05" "06" "07")
arraylength=${#GPVM_ARRAY[@]}
declare -a for_min_array
declare -a for_gpvm_array
declare -a matrix

#trap "echo CTL-C; exit" 0

check_ticket() {
trap "exit" INT
if [ `klist 2>&1 | grep -i 'No credentials' | wc -l` -gt 0 ]; then
echo -e "${blue}${bold}You do not have a valid ticket. Please kinit!${normal}"
kinit
fi
}

check_connection() {
echo -e "MINERvA \tUsers"
for ((i=0; i<${arraylength}; i++))
do
ssh_connection_check=$(ssh -K -X -Y $USER_INFO@minervagpvm${GPVM_ARRAY[i]}.FNAL.GOV who | wc -l)
echo -e "GPVM ${GPVM_ARRAY[i]}: ${ssh_connection_check}"
for_min_array+=($ssh_connection_check)
for_gpvm_array+=(${GPVM_ARRAY[i]})
matrix+=(${GPVM_ARRAY[i]} $ssh_connection_check)
done
}


connect_to_gpvm() {
min_array=$(echo "${for_min_array[*]}" | tr ' ' '\012' | sort -n | head -1)

min_user=$(expr 2*i+1)
min_gpvm=$(expr 2*i)

for ((i=0; i<${arraylength}; i++))
do
#echo -e "$[${min_user}] and $[${min_gpvm}]"
if [ "${min_array}" == "${matrix[${min_user}]}" ] ; then
echo -e "Minimum users is ${red}${matrix[${min_user}]}${normal} on GPVM ${red}${matrix[${min_gpvm}]}${normal}"
ssh_connect="ssh -K -X -Y $USER_INFO@minervagpvm${matrix[${min_gpvm}]}.FNAL.GOV"
echo -e "${ssh_connect}"
${ssh_connect}
exit
fi
done
}


help_function() {
clear
echo -e "-------------------------------------------------------------"
echo -e "|              MINERvA GPVM Login Script                    |"
echo -e "-------------------------------------------------------------"
echo -e "${underline}How to connect to MINERvA GPVM machine?${normal}"
echo -e ""
echo -e "./$(basename $BASH_SOURCE)\thelp\t\tget this help message"
echo -e "./$(basename $BASH_SOURCE)\t\t\tuse the dafault username"
echo -e "./$(basename $BASH_SOURCE)\tuser_name\tuse iserted user_name"
echo -e ""
echo -e "-------------------------------------------------------------"
echo -e "| Please contact $EXPERT for more details.|"
echo -e "-------------------------------------------------------------"
}

case "$1" in
"help" | "-help" | "--help" | "h" | "-h" | "usage" | "about")
  help_function
;;
"$nullVariable" | "$USER_INFO" )
  check_ticket
  check_connection
  connect_to_gpvm
;;
esac

