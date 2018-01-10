#!/bin/bash

. `dirname $0`/demo.conf

export JAVA_OPTS="$JAVA_OPTS -Djava.security.properties=$HOME/java.security.properties"

cat > secure-management-interface.cli <<END1
embed-server --server-config=standalone.xml
/core-service=management/management-interface=http-interface:write-attribute(name=ssl-context, value=twoWaySSC)
/core-service=management/management-interface=http-interface:write-attribute(name=secure-socket-binding, value=management-https)
stop-embedded-server
END1

echo
echo -n "Secure Management Interface ... "
$JBOSS_HOME/bin/jboss-cli.sh --file=secure-management-interface.cli &> /dev/null
IS_OK
echo

rm -f secure-management-interface.cli

