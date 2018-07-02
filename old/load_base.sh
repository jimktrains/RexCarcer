#!/bin/sh

base=$1

basebase=`grep base snapshots/$base.meta | cut -d = -f 2`


base_zvol=zroot/jails/$base
basebase_zvol=zroot/jails/$basebase
mountpoint=/usr/local/jails/$base

base_zsend=snapshots/$base.zfs.bz2

if [ ! -z $basebase ]; then
  base_in_list=`zfs list | grep $basebase_zvol`
  if [ -z $base_in_list ]; then
    $0 $basebase
  fi
  zfs clone -o mountpoint=$mountpoint $basebase_zvol $base_zvol
  zfs snapshot $base_zvol@first
fi

bzcat $base_zsend | zfs receive $base_zvol
zfs snapshot $base_zvol@applied
