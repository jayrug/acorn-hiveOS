#!/usr/bin/env bash
# This code is included in /hive/miners/custom/custom function

[ -t 1 ] && . colors
. h-manifest.conf

[[ -z $CUSTOM_TEMPLATE ]] && echo -e "${YELLOW}CUSTOM_TEMPLATE is empty${NOCOLOR}" && return 1
[[ -z $CUSTOM_URL ]] && echo -e "${RED}CUSTOM_URL is empty${NOCOLOR}" && return 1
[[ -z $CUSTOM_PASS ]] && CUSTOM_PASS="noreply@test.com" && echo -e "${YELLOW}CUSTOM_PASS is empty, replaced with noreply@test.com${NOCOLOR}"
[[ -z $CUSTOM_USER_CONFIG ]] && CUSTOM_USER_CONFIG="195" && echo -e "${YELLOW}CUSTOM_USER_CONFIG is empty, replaced with default freq${NOCOLOR}"

conf="%AURL% %APORT% %AWALLET% %AWORKER% $CUSTOM_PASS $CUSTOM_USER_CONFIG"

acorn_wallet=${CUSTOM_TEMPLATE%%.*} 
pool_url=`echo $CUSTOM_URL | cut -d "/" -f3 | cut -d ":" -f1` 
pool_port=${CUSTOM_URL##*:}

conf=$(sed "s/%AWALLET%/$acorn_wallet/g" <<< "$conf")
conf=$(sed "s/%AURL%/$pool_url/g" <<< "$conf") 
conf=$(sed "s/%APORT%/$pool_port/g" <<< "$conf")

[[ ! -z $WORKER_NAME ]] && conf=$(sed "s/%AWORKER%/$WORKER_NAME/g" <<< "$conf") #|| echo "${RED}WORKER_NAME not set${NOCOLOR}"

[[ -z $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}No CUSTOM_CONFIG_FILENAME is set${NOCOLOR}" && return 1
echo "$conf" > $CUSTOM_CONFIG_FILENAME
