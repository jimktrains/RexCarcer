#!/bin/sh

base=$2
basebase=$3



base_zvol=zroot/jails/$base
basebase_zvol=zroot/jails/$basebase

base_zsend=snapshots/$base.zfs.bz2

mountpoint=/usr/local/jails/$base

if [ ! -z $basebase ]; then
  zfs clone -o mountpoint=$mountpoint $basebase_zvol $base_zvol
  zfs snapshot $base_zvol@first
fi

bzcat $base_zsend | zfs receive $base_zvol
zfs snapshot $base_zvol@applies
