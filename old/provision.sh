#!/bin/sh

base_dir=/var/tmp/rexec

orgname=$1
jailname=$2

fqdn=`sh generate_hostname.sh $orgname $jailname`
rnd_part=`echo $fqdn | cut -d . -f 1`
ip6_addr=`sh generate_address.sh $orgname $hostname`
jail_fqdn=`echo $fqdn | cut -d . -f 2-`

root_dir=$base_dir/$orgname/$jailname/$rnd_part

# Generate host tls key
host_tls_key=$base_dir/usr/local/etc/ssl/$hostname.key.pem
host_tls_crt=$base_dir/usr/local/etc/ssl/$hostname.crt.pem
host_tls_fingerprint=`openssl x509 -noout -fingerprint -sha256 -in $host_tls_crt | sed 's/://g' | cut -d = -f 2


# Generate host ssh key
host_ssh_key=$base_dir/usr/local/etc/ssh/ssh_host_key
ssh-keygen -f $host_ssh_key -N '' -t ecdsa
host_ssh_dns_sshfp=`ssh-keygen -g -f $host_ssh_key -r $fqdn`

#TODO Download base image recursivly
#TODO Verify downloads
#TODO Apply bases in correct order

# Generate jail config
cat <<EOS
$fqdn {
  host.hostname = "$fqdn"
  path = "$root_dir";
  interface = "lo0";
  ip6.addr = "lo0|$ip6_addr/64"
}
EOS

# TODO: Generate DNSSEC records

# Generate unbound config
cat <<EOS
local-zone: "$fqdn" static
local-data-ptr: "$ip6_addr $fqdn"
local-data: "$fqdn IN AAAA $ip6_addr"
local-data: "_443._tcp.$fqdn IN TLSA \# 35 03 00 01 $host_tls_fingerprint"
local-data: "$host_ssh_dns_sshfp"

local-zone: "$jail_fqdn" static
local-data: "$jail_fqdn IN AAAA $ip6_addr"
EOS

#TODO Add fc::1 to the hosts file as jailer.localhost
#TODO Add jailer syslog to put this jails logs in a file
#TODO Add syslogd config to point to jailer


#TODO restart unbound
#TODO syslog unbound
#TODO Start jail
