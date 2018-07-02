#!/bin/sh

host=$1
user_crt=$2
dir=$3

user_key=`basename $user_crt .cert.pem`.key.pem
org=`openssl x509 -in $user_crt -text -noout | grep Subject: | sed 's/.*Subject: O=\([^,]*\).*/\1/'`

config_file=$dir/ca_config
ca_crt=$dir/certs/ca.cert.pem

host_key=$host.key.pem
host_csr=$host.csr.pem
host_crt=$host.cert.pem

##############################
# The following section should
# be done on the jailer
##############################
openssl genrsa \
  -out $host_key \
  4096

openssl req \
  -new \
  -config $config_file \
  -key $host_key \
  -out $host_csr \
  -subj "/CN=$host/O=$org"
################################

openssl ca \
  -config $config_file \
  -keyfile $user_key \
  -cert $user_crt \
  -extensions server_cert \
  -days 375 -notext \
  -in $host_csr \
  -out $host_crt

cat $user_crt >> $host_crt
