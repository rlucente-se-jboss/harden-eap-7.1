#!/bin/bash

. `dirname $0`/demo.conf

export JAVA_OPTS="-Djava.security.properties=$HOME/java.security.properties"

PUSHD ${WORK_DIR}

  echo
  echo -n "Installing EAP ... " 
  unzip -q ${BIN_DIR}/jboss-eap-${VER_DIST_EAP}.zip
  IS_OK

  if [ "x$(grep java.security.properties $JBOSS_HOME/bin/standalone.conf)" = "x" ]
  then
      for conf in standalone domain
      do
          echo -n "Adding FIPS provider $conf overrides ... "
          echo >> $JBOSS_HOME/bin/$conf.conf
          echo "# override security policy" >> $JBOSS_HOME/bin/$conf.conf
          echo 'JAVA_OPTS="$JAVA_OPTS '$JAVA_OPTS'"' >> $JBOSS_HOME/bin/$conf.conf
          IS_OK
      done
  fi

  echo -n "Setting admin password ... "
  ${JBOSS_HOME}/bin/add-user.sh -p 'admin1jboss!' -u admin --silent
  IS_OK

  if [ "x${VER_PATCH_EAP}" != "x" ]
  then
      echo -n "Applying patch ... "
      $JBOSS_HOME/bin/jboss-cli.sh --command="patch apply --override-all ${BIN_DIR}/jboss-eap-${VER_PATCH_EAP}-patch.zip" &> /dev/null
      IS_OK
  fi

  echo -n "Enabling Elytron subsystem ... "
  $JBOSS_HOME/bin/jboss-cli.sh --file=$JBOSS_HOME/docs/examples/enable-elytron.cli &> /dev/null
  IS_OK

  echo
POPD
