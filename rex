#!/bin/sh

local_dir=`dirname $0`

section=$1
command=$2
if [ ! -x $local_dir/commands/$section/$command ]; then
  echo `basename $0` $section $command is not a valid rex command >&2
  exit 1
fi

shift 2
$local_dir/commands/$section/$command $@
