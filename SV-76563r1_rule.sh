#!/bin/bash

. `dirname $0`/demo.conf

#
# Secure the management https interface
#

echo
echo -n "Creating self-signed web server certificate ... "
keytool -genkeypair \
    -alias appserver \
    -keyalg RSA \
    -keysize 3072 \
    -dname "CN=AppServer, OU=JBoss, O=Red Hat, L=Raleigh, S=NC, C=US" \
    -validity 365 \
    -keypass 'secret' \
    -keystore $JBOSS_HOME/standalone/configuration/keystore.bcfks \
    -storepass 'secret' \
    -storetype BCFKS \
    -providername BCFIPS \
    -providerclass org.bouncycastle.jcajce.provider.BouncyCastleFipsProvider \
    -v \
    -J-Djava.security.properties=$WORK_DIR/java.security.properties &> /dev/null
    IS_OK

echo -n "Enabling server TLS for management interface ... "
JAVA_OPTS="-Djava.security.properties=$WORK_DIR/java.security.properties" \
    $JBOSS_HOME/bin/jboss-cli.sh --file=SV-76563r1_rule.cli &> /dev/null
IS_OK
echo
