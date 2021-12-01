#!/bin/bash

#Variables for functions default, or given with input.
INSTALL_DIR="${1}"
DATA_DIR="${INSTALL_DIR}"/"Logs_downloads_squid"
LOGFILE="${DATA_DIR}"/"Installation_and_commands.log"

#Variables that makes text appear just a little fancier.

RED='\033[0;31m'
NC='\033[0m'
LPURPLE='\033[1;35m'
YEL='\033[1;33m'
BLINKRED='\033[5;31m'
BLINKPURP='\033[5;35m'

#Function to let text appear in a rolling-out fashion
roll() {
  msg="${1}"
    if [[ "${msg}" =~ ^=.*+$ ]]; then
      speed=".01"
    else
      speed=".03"
    fi
  let lnmsg=$(expr length "${msg}")-1
  for (( i=0; i <= "${lnmsg}"; i++ )); do
    echo -n "${msg:$i:1}"
    sleep "${speed}"
  done ; echo ""
}


#Function to declare an initial directory for environment and potentially logging (might add later)
start() {
	if [[ -d "$DATA_DIR" ]]; then
		echo "" ; touch "${LOGFILE}"
		roll "Data directory is already made, skipping..."
	else
		mkdir -p "${DATA_DIR}" ; touch "${LOGFILE}"
		roll "Data directory is made, together with logfile; going next."
	fi
		cd "${DATA_DIR}"
}

#Function to install squid package
install_squid() {
echo -e "${BLINKRED}yum install squid*${NC}${YEL}"
}

#Function to start squid after install
start_squid() {
echo -e "${RED}systemctl start squid${NC}${YEL}"
}

echo -e  "${BLINKPURP}###${NC} ${RED}Welcome to${NC} ${LPURPLE}Nick's${NC} ${RED}squid-proxy server roll-out script${NC}${BLINKPURP} ###${NC}${YEL}"
roll "Please follow the upcoming instructions and insertion of variables"

roll "Starting out by installing Squid!"

start
install_squid
start_squid
