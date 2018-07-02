#!/bin/sh

user_csr=$1
user_crt=`basename $user_csr .csr.pem`.cert.pem

dir=$2

config_file=$dir/ca_config
ca_crt=$dir/ca.cert.pem

openssl ca \
  -config $config_file \
  -days 3650 -notext \
  -in $user_csr \
  -out $user_crt

cat $ca_cert >> $user_crt
