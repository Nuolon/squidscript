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
roll "Started the installation of squid, please sit tight."
echo -e "${RED}yum install squid* 2>&1 ${DATA_DIR}/${LOGFILE}${NC}${YEL}"
roll "Installation finished, moving on..."
echo -e "${LPURPLE}================================================================${NC}"
}

#Function to start squid after install and add to startup
start_squid() {
roll "Starting squid..."
echo -e "${RED}systemctl start squid 2>&1 ${DATA_DIR}/${LOGFILE} ${NC}${YEL}"
echo -e "${RED}systemctl enable squid 2>&1 ${DATA_DIR}/${LOGFILE} ${NC}${YEL}"
roll "Squid started and enabled on start-up"
echo -e "${LPURPLE}================================================================${NC}"
}

#function to restart squid
restart_squid() {
roll "Restarting squid..."
echo -e "${RED}systemctl restart squid 2>&1 ${DATA_DIR}/${LOGFILE} ${NC}${YEL}"
roll "Squid restarted"
echo -e "${LPURPLE}================================================================${NC}"
}

#Function to change the configuration file  of squid.
conf_squid() {
roll "Starting to configure squid..."
echo -e "${RED}echo 'acl all src 0.0.0.0/0' >> /etc/squid/squid.conf ${NC}${YEL}"
echo -e "${RED}echo 'http_access allow all' >> /etc/squid/squid.conf ${NC}${YEL}"
echo -e "${RED}echo 'acl forbiddensites url_regex "/etc/squid/forbiddensites"' ${NC}${YEL}"
echo -e "${RED}echo 'http_access deny forbiddensites' >> /etc/squid/squid.conf ${NC}${YEL}"
echo -e "${RED}echo '.facebook.com' >> /etc/squid/forbiddensites  ${NC}${YEL}"
echo -e "${RED}firewall-cmd --permanent --add-port=3128/tcp 2>&1 ${DATA_DIR}/${LOGFILE} ${NC}${YEL}"
echo -e "${RED}firewall-cmd --reload 2>&1 ${DATA_DIR}/${LOGFILE} ${NC}${YEL}"
roll "Done, basic acl's made and added a forbidden list."
echo -e "${LPURPLE}================================================================${NC}"
}

echo -e  "${BLINKPURP}###${NC} ${RED}Welcome to${NC} ${LPURPLE}Nick's${NC} ${RED}squid-proxy server roll-out script${NC}${BLINKPURP} ###${NC}${YEL}"
roll "Please follow the upcoming instructions and insertion of variables"

roll "Starting out by installing Squid!"
start
install_squid
start_squid
conf_squid
restart_squid

