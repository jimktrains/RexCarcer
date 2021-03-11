#!/bin/sh

. rex.conf

if [ ! -z "$1" ]; then
  REXFILE="$1" 
fi

NAME=`basename $REXFILE .rex`
JAILDIR=$POOL/$NAME
JID=
while read line
do
  echo $line | grep ^# && continue
  cmd=`echo $line | awk '{print $1}' | tr a-z A-Z`
  args=`echo $line | awk '{$1="";print}'`
  case $cmd in
    FROM)
      echo "I'm going to fetch an image: $args"
      zfs list -H "$args"
      if [ ! $? ]; then
        echo "OK, I lied. I don't know how to fetch anything"
        #exit 1
      fi
      echo "Going to use $BASE_JAILDIR as my base for $NAME"
      zfs clone "$args" "$JAILDIR"
      JID=`jail -i -c name="$NAME" path="$JAILDIR"`
      echo "Created jail $JID"
      ;;
    RUN)
      echo "Running $args"
      jail -mr jid=$JID exec.clean="$args"
      ;;
    COPYALL)
      echo "Copying everything from 'pwd'/**/* to '/'"
      find . -mindepth 1 -type d -exec mkdir -p "$JAILDIR"/{} \;
      find . -mindepth 1 -type f -exec cp {} "$JAILDIR"/{} \;
      ;;
    COPY)
      src=`echo $args | awk 'BEGIN{FPAT = "([^[:space:]]+)|(\"[^\"]+\")"}{print $1}'`
      dst=`echo $args | awk 'BEGIN{FPAT = "([^[:space:]]+)|(\"[^\"]+\")"}{print $2}'`
      echo "Copying '$src' to '$dst'"
      cp -r "$src" "$JAILDIR"/"$dst"
      ;;
    ENV)
      echo "Setting global env var $args"
      jail -mr jid=$JID exec.clean="sed -e 's/\(:setenv=.*\):\\/\1,$args:\\/g' -i /etc/login.conf"
      ;;
  esac
done < "$REXFILE"
