i2017-11-20
install RHEL 7 VM called "RHEL" on Virtualbox using RHEL 7.4 image
create administrator named "rlucente" with password "redhat"
yum -y update
yum -y install java-1.8.0-openjdk-devel
ip address is 192.168.56.101
sudo firewall-cmd --permanent --add-port=9993/tcp
backup ~/VirtualBox VMs/RHEL/RHEL.vdi.tgz so can quickly return to no change
create ~/java.security.properties file with modified provider list and FIPS mode
 enabled for JSSE
sudo cp bc-fips-1.0.0.jar to /usr/lib/jvm/jre/lib/ext
initial commit
sudo yum -y install unzip
create scripts for installing eap 7.1

configure SSL/TLS in elytron by creating a `key-store`, `key-manager`, and `serv
er-ssl-context`.
set `secure-socket-binding` on the http-interface and assign `server-ssl-context
` to the management interfaces.
Good reference here https://docs.jboss.org/author/display/WFLY/Using+the+Elytron
+Subsystem#UsingtheElytronSubsystem-EnableTwowaySSL%2FTLSfortheManagementInterfa
cesusingtheElytronSubsystem
Create the `SV-7653r1_rule.sh` and `SV-7653r1_rule.cli`
