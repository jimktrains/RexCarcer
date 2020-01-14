#!/bin/sh

name=$1
org=$2
dir=$3

config_file=$dir/ca_config
ca_crt=$dir/ca.cert.pem

user_key=$name.key.pem
user_csr=$name.csr.pem

openssl genrsa \
  -out $user_key \
  4096
  #-aes256 \

openssl req \
  -config $config_file \
  -new  \
  -key $user_key \
  -out $user_csr \
  -subj "/CN=$name/O=$org" \
