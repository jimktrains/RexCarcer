#!/bin/sh

. "../mustache.sh/lib/mustache.sh"

name=$1
dir=$2

config_file=$dir/ca_config
ca_key=$dir/private/ca.key.pem
ca_crt=$dir/certs/ca.cert.pem

rm -rf $dir
mkdir -p $dir/certs $dir/crl $dir/newcerts $dir/private
chmod 700 $dir/private
touch $dir/index.txt
echo 1000 > $dir/serial

mustache < "ca_config.mustache" > $config_file

openssl genrsa \
  -out $ca_key 4096 \
  #-aes256 \

chmod 400 $ca_key

openssl req \
  -config $config_file \
  -key $ca_key \
  -new -x509 -days 7300 \
  -subj "/CN=$name CA/O=$name" \
  -out $ca_crt

chmod 444 $ca_crt
