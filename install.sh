#!/bin/bash

. `dirname $0`/demo.conf

PUSHD ${WORK_DIR}

  if [ $(find . -type d -name jboss-eap-$VER_INST_EAP | wc -l) -eq 1 ]
  then
    echo
    echo -n "Do you want to delete existing installations? <y/N> "
    read answer

    if [ "x$answer" = "xY" -o "x$answer" = "xy" ]
    then
      ./clean.sh
    fi
  fi

  echo
  echo -n "Installing EAP ... "
  unzip -q ${BIN_DIR}/jboss-eap-${VER_DIST_EAP}.zip
  IS_OK

  echo -n "Setting admin password ... "
  ${JBOSS_HOME}/bin/add-user.sh -p 'admin1jboss!' -u admin --silent
  IS_OK

  if [ "x${VER_PATCH_EAP}" != "x" ]
  then
      echo -n "Applying patch ... "
      $JBOSS_HOME/bin/jboss-cli.sh --command="patch apply --override-all ${BIN_DIR}/jboss-eap-${VER_PATCH_EAP}-patch.zip" &> /dev/null &> /dev/null
      IS_OK
  fi

  echo -n "Enabling Elytron subsystem ... "
  $JBOSS_HOME/bin/jboss-cli.sh --file=$JBOSS_HOME/docs/examples/enable-elytron.cli &> /dev/null
  IS_OK

  echo
POPD
