#!/bin/bash

. `dirname $0`/demo.conf

PUSHD ${WORK_DIR}
  rm -fr jboss-eap-${VER_INST_EAP}
POPD

