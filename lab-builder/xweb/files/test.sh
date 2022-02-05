#!/bin/bash
COLUMN=SvcMon
COLOR=""
MSG=""
HEADER_CELL="<th class=\"dataframe\">%s</th>\n"
GENERAL_TD="<td class=\"dataframe\">%s</td>\n"
RED_TD="<td class=\"dataframered\">%s</td>\n"
CUSTOM_CSS=(
    "\n <style>
    \n table { text-align: left; border-collapse: collapse; }
    \n table td, table.dataframe th { padding: 3px 2px; text-align: center;}
    \n table th { font-weight: bold; text-decoration: underline; text-align: center;}
    \n table tr:hover {background-color: #333333;}
    \n .tdred { color: red; }\
    \n </style>"
)

ACTIVECOUNT=0
REDCOUNT=0

MSG=$(echo -e "$CUSTOM_CSS\n$MSG\n<table><tr><th>SERVICE</th><th>STATUS</th></tr>")

# redirect errors to logfile using fd3
exec 3>&1

#build running services list
systemctl --type=service --state=running | awk '{print $1}' | grep -E 'redis|mosquitto|nginx' > /tmp/running_svcs.list
for i in $(cat /tmp/running_svcs.list); do
    if [[ $i == 'nginx.service' ]]; then
        SVCCOLOR=GREEN
        MSG=$(echo -e"$MSG\n<tr><td>$i</td><td>$SVCCOLOR</td></tr>")
    else
        SVCCOLOR=RED
        MSG=$(echo -e"$MSG\n<tr><td>$i</td><td>$SVCCOLOR</td></tr>")
        REDCOUNT+=1
    fi
    if [[ $i == 'mosquitto.service' ]]; then
        SVCCOLOR=GREEN
        MSG=$(echo -e"$MSG\n<tr><td>$i</td><td>$SVCCOLOR</td></tr>")
    else
        SVCCOLOR=RED
        MSG=$(echo -e"$MSG\n<tr><td>$i</td><td>$SVCCOLOR</td></tr>")
        REDCOUNT+=1
    fi
    if [[ $i == 'redis.service' ]]; then
        SVCCOLOR=GREEN
        MSG=$(echo -e"$MSG\n<tr><td>$i</td><td>$SVCCOLOR</td></tr>")
    else
        SVCCOLOR=RED
        MSG=$(echo -e"$MSG\n<tr><td>$i</td><td>$SVCCOLOR</td></tr>")
        REDCOUNT+=1
    fi
done
  
#cleanup tmp file
rm /tmp/running_svcs.list

if [[ $REDCOUNT -ge 1 ]];then
    COLOR=red
else
    COLOR=green
fi

# close fd3
exec 3>&-

# add the footer
MSG=$(echo -e "$MSG\n</table>")

echo -e "$MSG\n\n$COLOR"

# add the timestamp
###MSG="<center>$(date)</center>$MSG"

# Tell Xymon about it
###$XYMON $XYMSRV "status $MACHINE.$COLUMN $COLOR ${MSG}"

exit 0


