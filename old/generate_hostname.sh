#!/bin/sh

orgname=$1
jailname=$2

echo `openssl rand -hex 8`.$jailname.$orgname.localhost
