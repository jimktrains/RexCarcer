#!/bin/sh

snapshot_name=$1
base=$2
sig_crt=$3
sig_key=`basename $sig_crt .cert.pem`.key.pem

sig_fp=`openssl x509 -in $sig_crt -fingerprint -sha256 -noout | sed 's~SHA256 Fingerprint=~~' | sed 's~:~~g'`

snapshot_file=$snapshot_name.zfs.bz2
snapshot_meta=$snapshot_name.meta
snapshot_sig=$snapshot_name.sha256sig.$sig_fp


if [ -z $base ]; then
  zfs send $snapshot_name | bzip2 -9 > $snapshot_file
else
  zfs send -i $snapshot_name@first $snapshot_name@applied | bzip2 -9 > $snapshot_file
fi
echo "base=$base" > $snapshot_meta

hfile=`mktemp`
openssl dgst -sha256 -out $hfile $snapshot_file $snapshot_meta
openssl dgst -sha256 -sign $sig_key -out $snapshot_sig $hfile

zsyncmake -u $snapshot_file $snapshot_file
zsyncmake -u $snapshot_meta $snapshot_meta
zsyncmake -u $snapshot_sig $snapshot_sig
