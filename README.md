# Harden EAP 7.1
This guide provides instructions for the hardening of EAP 7.1.  Rules are copied from the DISA EAP 6.3 STIG and adapted for EAP 7.1.

## Install Operating System
First, install RHEL 7.4 and create a user account with administrator
privileges.  Use `subscription-manager` to register with RHSM.
Attach a subscription pool and make sure to enable the `rhel-7-server-rpms`
repository.  Then do the following:

    sudo yum -y update
    sudo yum -y install java-1.8.0-openjdk-devel unzip git
    sudo yum -y clean all
    sudo systemctl reboot

Once the system reboots, note the IP address.

## Install Bouncy Castle FIPS Provider
Download the [Legion of the Bouncy Castle FIPS
Provider](https://bouncycastle.org/fips-java).  This file should
be `bc-fips-1.0.0.jar`.  Copy the file to the jre extensions.

    sudo cp bc-fips-1.0.0.jar to /usr/lib/jvm/jre/lib/ext

## Install EAP
Download the latest available distribution of EAP 7.1.  The file
should be named similar to `jboss-eap-7.1.0.CR4.zip`.  Put this
file in the directory `$HOME/Downloads`.

Clone this repository onto the system so that you can run the various
installation scripts.

    git clone https://github.com/rlucente-se-jboss/harden-eap-7.1.git
    cd harden-eap-7.1

Next, run the scripts to install EAP 7.1 and set `JAVA_OPTS` to
override the default `java.security` policy file. The overridden
file will set Bouncy Castle FIPS as the first provider and
enable "FIPS mode" for the SunJSSE provider.

    ./clean.sh
    ./install.sh
    ./override-java-security-policy.sh

## Run Various Hardening Tasks
The list of tasks map to the STIG identifiers in the EAP 6.3 STIG.
The first task sets the management interface to use TLSv1.2 with a
self-signed certificate and the BCFIPS provider.

    ./SV-76563r1_rule.sh
    
## CLI Reference for Elytron Configuration
There's a good reference of Elytron CLI commands
[here](https://docs.jboss.org/author/display/WFLY/Using+the+Elytron+Subsystem).

