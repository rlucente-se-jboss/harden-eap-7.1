#!/bin/bash

. `dirname $0`/demo.conf

echo
echo -n "Create key used to encrypt credential entries ... "
keytool -genseckey \
    -J-Djava.security.properties=$HOME/java.security.properties \
    -keystore NONE \
    -storetype PKCS11 \
    -storepass 'admin1jboss!' \
    -alias cskey \
    -keyalg AES \
    -keysize 256 &> /dev/null
IS_OK

# org.wildfly.security.util.PasswordBasedEncryptionUtil.Builder.salt
# can only be provided a UTF-8 string.  Further, this must be eight
# bytes (or UTF-8 characters) in length.  Should be able to submit a
# random base-64 encoded value but the random salt below is selected
# from 2^32 possibilities.

RAND_SALT=$(openssl rand -hex 4)

# PBE-based password masking should fail when FIPS compliant but
# the SunPKCS11 provider focuses only on TLS operations.  The Bouncy
# Castle FIPS provider with a security manager configured for approved
# mode only will reject PBE-based password masking

export JAVA_OPTS="$JAVA_OPTS -Djava.security.properties=$HOME/java.security.properties"
MASKED_PASSWORD=$($JBOSS_HOME/bin/elytron-tool.sh mask -i 1000 -s $RAND_SALT -x 'admin1jboss!')

cat > create-credential-store.cli <<END1
embed-server --server-config=standalone.xml
/subsystem=elytron/credential-store=fips:add(modifiable=true, location=data.store, relative-to=jboss.server.data.dir, implementation-properties={"keyStoreType"=>"PKCS11","external"=>"true","keyAlias"=>"cskey"},credential-reference={clear-text="$MASKED_PASSWORD"}, create=true)
/subsystem=elytron/credential-store=fips:add-alias(alias="keystorePassword", secret-value="admin1jboss!")
stop-embedded-server
END1

echo -n "Create the credential store ... "
$JBOSS_HOME/bin/jboss-cli.sh --file=create-credential-store.cli &> /dev/null
IS_OK
echo

rm -f create-credential-store.cli

