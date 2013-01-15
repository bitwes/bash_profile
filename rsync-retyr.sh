#!/bin/bash

### ABOUT: See: http://gist.github.com/366269
### Runs rsync, retrying on errors up to a maximum number of tries.
### On failure script waits for internect connection to come back up by pinging google.com before continuing.
###
### Usage: $ ./rsync-retry.sh source destination
### Example: $ ./rsync-retry.sh user@server.example.com:~/* ~/destination/path/
###
### INPORTANT:
### To avoid repeated password requests use public key authentication instead of passwords
### "ssh-keygen" (with no password), then "ssh-copy-id user@server.example.com"

# ----------------------------- rSync Options ------------------------------------------------

OPT="--inplace -vzP"

# -------------------- Shouldn't need to change anything bellow -------------------------------
echo -n "Enter No. of retries to attempt... "
read MAX_RETRIES

echo -n "Recursive flag ON? (y/n) "
read YN
if [[ $YN == "y" || $YN == "Y" ]]; then
RFLAG=r
fi

COM="rsync $OPT$RFLAG -e 'ssh -o \"ServerAliveInterval 10\"' $1 $2"

echo
echo "Using command: $COM"

# Trap interrupts and exit instead of continuing the loop
trap "echo Ctl+C Detected... Exiting!; exit;" SIGINT SIGTERM

COUNT=0
START=$SECONDS

# Set the initial exit value to failure
false
while [ $? -ne 0 -a $COUNT -lt $MAX_RETRIES ]; do
COUNT=$(($COUNT+1))
if [ $COUNT -ne 1 ]; then
echo
echo "Waiting for Internet connection..."
false
until [ $? -eq 0 ]; do
wget -q --tries=10 --timeout=5 http://www.google.com -O /tmp/index.google &> /dev/null
done
fi
echo
echo "Attempt No. $COUNT / $MAX_RETRIES"
echo
## Havn't got the quoting quite right above to just have $COM here.
#$COM
rsync -vzP$RFLAG --inplace -e 'ssh -o "ServerAliveInterval 10"' $1 $2
done

FINISH=$SECONDS
if [[ $(($FINISH - $START)) -gt 3600 ]]; then
ELAPSED="$((($FINISH - $START)/3600))hrs, $(((($FINISH - $START)/60)%60))min, $((($FINISH - $START)%60))sec"
elif [[ $(($FINISH - $START)) -gt 60 ]]; then
ELAPSED="$(((($FINISH - $START)/60)%60))min, $((($FINISH - $START)%60))sec"
else
ELAPSED="$(($FINISH - $START))sec"
fi

if [ $COUNT -eq $MAX_RETRIES -a $? -ne 0 ]; then
echo "Hit maximum number of retries($MAX_RETRIES), giving up. Elapsed time: $ELAPSED"
fi

if [ $? -eq 0 ]; then
echo "Finished after $COUNT retries!! Elapsed time: $ELAPSED"
fi