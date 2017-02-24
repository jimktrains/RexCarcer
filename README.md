# RexCarcer

FreeBSD Jail Manager and Cluster Manager. Provides ways to provisions jails
but also share services and DNS across them.

## Example:
public-docs.rex

    BASE https://example.com/freebsd/FreeBSD-11-REALSE
    PROVISION RUN pkg install nginx
    PROVISION COPY ./public /var/www
    PROVISION COPY nginx.conf /usr/local/etc/nginx/nginx.conf
    # Bind to a public IP associated with this box
    # A and SRV record will be placed in cluster DNS
    HOSTNAME docs.example.com
    IP 8.8.8.8/24

internal-renderer.rex

    BASE https://example.com/freebsd/FreeBSD-11-REALSE
    PROVISION RUN ...
    # IP and hostname will be auto assigned
    # SRV record will be placed in cluster DNS
    SERVICE renderer PORT 1234

## Jailer Services:
  * etcd
  * skydns
  * peroit master
  * ZFS
  * rsyslog
  * ntpd

## Jail Config files
  * /etc/resolv.conf - points ot skydns for this cluster in the jailer
  * /etc/rc.d/netconf - IP, hostname
  * /etc/rc.d/envvars - any environment variables
  * /etc/ssl/peroit-host.key - This host's TLS key
  * /etc/ssl/peroit-host.crt - This host's TLS cert 
  * /etc/ssl/peroit-cluster.crt - This cluster's CA
  * /etc/rsyslog - Points to the rsyslog server in the jailer

## Bringing up a jail
  * Check if JAIL exists, if not:
    * Bring up base
    * ZFS clone base
    * Provision
    * ZFS snapshot jail
  * ZFS clone jail
  * Assign IP using etcd to get correct subnet and available id for CA
  * Create configs
  * Start jail
  * Public IP and SERVICE and/or HOSTNAME to etcd for skydns
