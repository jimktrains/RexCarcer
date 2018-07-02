#!/bin/sh

orgname=$1
hostname=$2

ula_prefix=fc
org_prefix=`echo -n $orgname | \
  openssl dgst -md5 | \
  cut -d ' ' -f 2 | \
  sed 's/^\(..\)\(....\)\(....\)\(....\).*/\1:\2:\3:\4:/' | \
  tr -d '\r\n'`
jail_prefix=`echo -n $hostname | \
  openssl dgst -md5 | \
  cut -d ' ' -f 2 | \
  sed 's/^\(....\)\(....\)\(....\)\(....\).*/\1:\2:\3:\4/' | \
  tr -d '\r\n'`
echo "$ula_prefix$org_prefix$jail_prefix"
