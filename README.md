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
  * etcd (eventually)
  * skydns (eventually)
  * unbound (right now)
  * ZFS
  * rsyslog
  * ntpd

## Jail Config files
  * /etc/resolv.conf - points ot skydns for this cluster in the jailer
  * /etc/rc.d/netconf - IP, hostname
  * /etc/rc.d/envvars - any environment variables
  * /etc/ssl/rc/host.key - This host's TLS key
  * /etc/ssl/rc/host.crt - This host's TLS cert 
    * Probably will be chained via the user's cert
  * /etc/ssl/rc/cluster.crt - This cluster's CA
  * /etc/rsyslog - Points to the rsyslog server in the jailer
    * Could this be static and point to the host `logger`?

## Bringing up a jail
  * Check if JAIL exists, if not:
    * Bring up base
    * ZFS clone base
    * rsync snapshot and metadata
      * maybe zsync to lighten the load on servers?
    * verify snapshot
      * hfile=`mktemp`
        fp=`openssl x509 -in "$(whoami)s Sign Key.crt" -fingerprint -sha256 -noout | sed 's~SHA256 Fingerprint=~~' | sed 's~:~~g'`
        openssl dgst -sha256 snapshots/FreeBSD-11-RELEASE.zfs.bz2 snapshots/FreeBSD-11-RELEASE.base > $hfile
        openssl dgst -sha256 -sign "$(whoami)s Sign Key.key" -out snapshots/FreeBSD-11-RELEASE.sha256sig.$fp $hfile
        openssl dgst -sha256 -verify  <(openssl x509 -in "$(whoami)s Sign Key.crt"  -pubkey -noout) -signature snapshots/FreeBSD-11-RELEASE.sha256sig.$fp  $hfile
    * ZFS recieve snapshot
      * bzcat snapshots/FreeBSD-11-RELEASE.zfs.bz2 | zfs recieve
  * ZFS clone jail
  * Provision
  * Assign IP using flock to get correct subnet and available id for CA
  * Create configs
  * Start jail
  * Public IP and SERVICE and/or HOSTNAME to unbound local-data / reload unbound
