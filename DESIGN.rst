Rex Carcer Design
-----------------

Objects
=======

* Organizations
* Projects
* Users
* Networks
* Images
* Running Image

All objects are associated with a certificate, which has a unique DN.

Organizations
+++++++++++++
Organizations (DN: O=) are the "top-leve" owner of all other objects and
the CA used to sign all other object's certificates.  An Organization's
certificate is self-signed.

Fields
*******

Commands
********

create <name>
  Creates the Organization CA

sign-csr [-o <orgname>] <csr-file>
  Signs a CSR file. Org is optional if set in the client config.

Projects
++++++++
Projects (DN: O=,OU=) represent the configuration for a set of Networks
and Images.

Fields
*******

running_image_envvars
  Default Environment Variables to set for Running Images

Commands
********

Users
+++++
Users (DN: O=,dnQualifier=User,CN=) represent accounts that can request
other actions to be preformed, e.g. creating networks and running
images, by the hosts and that can ask for other objects, e.g. Networks
and Images, to be signed.

Fields
*******

Commands
********

create-csr [-o <orgname>] <name>
  Creates a new user csr and privkey. Org is optional if set in the
  client config.


Networks
++++++++
Networks (DN: O=,dnQualifier=Network,CN=) represent the configuration of
the virtual network that images connect to.

Fields
*******

Commands
********

Running Image
+++++++++++++
Images (DN: O=,OU=,dnQualifier=Image,CN=) represents an image that a jail
can be generated from.

Fields
*******

Commands
********

fetch [-r <repository url>] <name>
  Fetches a named image

build <file>
  Builds an image from a Rexfile

push [-r <repository url>] <name>
  Pushes an image to a repository

run [-h <cluster>] <name>
  Runs an image on a cluster

Running Image
+++++++++++++
Running Images (DN: O=,OU=,dnQualifier=RunningImage,CN=) represents a
running image inside of a project.

Fields
*******

Commands
********

Default Environment Variables
*****************************

In addition to anything specified in the Project, the following are also
set up by default.

RXC_SYSLOG_HOST
  Host that syslog messages can be sent to.

RXC_SYSLOG_PORT
  Port on $SYSLOG_HOST that messages can be sent to.

RXC_RI_CERT_PATH
  Path where the PEM-encoded X509 certificate for this Running Image can
  be found.

RXC_RI_CERT_PRIVKEY
  Path where the PEM-encoded private key for $RXC_RI_CERT_PRIVKEY can be
  found.
