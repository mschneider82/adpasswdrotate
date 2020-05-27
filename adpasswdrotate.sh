#!/bin/bash


if ! type "dig" > /dev/null 2>&1; then
  echo Please install dig. e.g. apt install dnsutils
  exit 1
fi

if ! type "smbpasswd" > /dev/null 2>&1; then
  echo Please install smbpasswd. e.g. apt install samba-common-bin
  exit 1
fi

echo Please type your AD Domainname:
read D

REMOTEIP=$(dig SRV +noall +additional _ldap._tcp.dc._msdcs.$D | awk '{print $5}'|head -n 1)
if test -z $REMOTEIP; then 
  echo Please type your AD-Server IP or HOSTNAME
  read REMOTEIP
fi

echo Please type your username:
read U
if test -z $U; then echo Error: username cannot be empty ; exit 1 ; fi

echo Please type your current AD Password:
read -s ORIGPASS
if test -z $ORIGPASS; then echo Error: password cannot be empty ; exit 1 ; fi

echo "How many times to rotate? (default 30)"
read N
if test -z $N; then N=30 ; fi

OLD=${ORIGPASS}

for i in $(seq 1 $N)
do
  NEW=${ORIGPASS}$i
  echo set password with suffix $i
  echo -e "${OLD}\n${NEW}\n${NEW}" | smbpasswd -s -U $U -r $REMOTEIP
  if [ $? -eq 1 ] 
  then
    echo error last password was: ${OLD}
    exit 1
  fi
  OLD=${NEW}
done

echo Set password back to your old password...
echo -e "${NEW}\n${ORIGPASS}\n${ORIGPASS}" | smbpasswd -s -U $U -r $REMOTEIP
if [ $? -eq 1 ] 
  then
    echo error last password was: ${NEW}
    exit 1
fi

echo Finished OK.
exit 0
