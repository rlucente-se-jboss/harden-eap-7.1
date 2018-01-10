#!/bin/bash

# make sure that all certs are available
if [ -r "$HOME/server.p12" -a -r "$HOME/client.p12" ]
then
    echo "All needed certificates found."
else
    echo "Needed certificates are missing!"
    exit 1
fi

# all passwords are set to admin1jboss!
echo 'admin1jboss!' > pwdfile.txt
chmod 600 pwdfile.txt

# initialize NSS database
mkdir -p $HOME/fipsdb
modutil -force -dbdir $HOME/fipsdb -create
modutil -force -dbdir $HOME/fipsdb -fips true
modutil -force -dbdir $HOME/fipsdb -changepw "NSS FIPS 140-2 Certificate DB" -newpwfile pwdfile.txt

# import server cert, key, and CAs
pk12util -i $HOME/server.p12 -d $HOME/fipsdb -k pwdfile.txt -w pwdfile.txt

# trust intermediate and root authorities
echo "When requested, token PIN is $(cat pwdfile.txt)"
certutil -M -n 'Red Hat Root CA Test - Red Hat' -t 'TC,C,C' -d $HOME/fipsdb
certutil -M -n 'Red Hat Intermediate CA Test - Red Hat' -t 'TC,C,C' -d $HOME/fipsdb

rm -f pwdfile.txt

echo
echo "The following files are needed by JBoss EAP 7.1:"
echo
echo "    $HOME/fipsdb"
echo "    $HOME/java.security.properties"
echo "    $HOME/nss-pkcs11-fips.cfg"
echo
echo "The client cert, key, and cert chain are available in pkcs12 format here:"
echo
echo "    $HOME/client.p12"
echo
