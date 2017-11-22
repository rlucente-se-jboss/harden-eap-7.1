#!/bin/bash

. `dirname $0`/demo.conf

PUSHD ${WORK_DIR}

  echo
  echo -n "Overriding java.security policy ... "
  JAVA_POLICY_OVERRIDDEN=$(grep java.security.properties $JBOSS_HOME/bin/standalone.conf)
  if [ "x$JAVA_POLICY_OVERRIDDEN" = "x" ]
  then
    echo >> $JBOSS_HOME/bin/standalone.conf
    echo 'JAVA_OPTS="$JAVA_OPTS -Djava.security.properties='$WORK_DIR'/java.security.properties"' >> \
      $JBOSS_HOME/bin/standalone.conf
    echo >> $JBOSS_HOME/bin/standalone.conf
  fi
  IS_OK
  echo

POPD
