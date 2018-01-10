#!/bin/bash

# make sure that all certs are available
if [ -r "$HOME/ca.cert.pem" -a -r "$HOME/intermediate.cert.pem" -a -r "$HOME/server.p12" -a -r "$HOME/client.p12" ]
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

# import root CA with appropriate trust args
certutil -A -n root_ca -t "TC,C,C" -f pwdfile.txt -d $HOME/fipsdb -i $HOME/ca.cert.pem

# import intermediate CA
certutil -A -n intermediate_ca -t "T,," -f pwdfile.txt -d $HOME/fipsdb -i $HOME/intermediate.cert.pem

# import server cert and key
pk12util -i $HOME/server.p12 -d $HOME/fipsdb -k pwdfile.txt -w pwdfile.txt

rm -f pwdfile.txt

echo
echo "The following files are needed by JBoss EAP 7.1:"
echo
echo "    $HOME/fipsdb"
echo "    $HOME/java.security.properties"
echo "    $HOME/nss-pkcs11-fips.cfg"
echo
echo "The client cert, key, and trusted root CA are available in these files:"
echo
echo "    $HOME/client.p12"
echo "    $HOME/ca.cert.pem"
echo
