#!/bin/bash

. `dirname $0`/demo.conf

export JAVA_OPTS="$JAVA_OPTS -Djava.security.properties=$HOME/java.security.properties"

# Only TLSv1.1 or earlier with SunPKCS11

cat > configure-tls.cli <<END1
embed-server --server-config=standalone.xml
/subsystem=elytron/key-store=twoWayKS:add(credential-reference={alias=keystorePassword, store=fips}, type=PKCS11)
/subsystem=elytron/key-store=twoWayTS:add(credential-reference={alias=keystorePassword, store=fips}, type=PKCS11)
/subsystem=elytron/key-manager=twoWayKM:add(key-store=twoWayKS,credential-reference={alias=keystorePassword, store=fips})
/subsystem=elytron/trust-manager=twoWayTM:add(key-store=twoWayTS)
/subsystem=elytron/server-ssl-context=twoWaySSC:add(key-manager=twoWayKM,protocols=["TLSv1.1"],trust-manager=twoWayTM,want-client-auth=true,need-client-auth=true)
stop-embedded-server
END1

echo
echo -n "Configure TLS/SSL ... "
$JBOSS_HOME/bin/jboss-cli.sh --file=configure-tls.cli &> /dev/null
IS_OK
echo

rm -f configure-tls.cli

