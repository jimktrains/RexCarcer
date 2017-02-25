#!/bin/sh

host=$1

echo $host-`openssl rand -hex 8`
