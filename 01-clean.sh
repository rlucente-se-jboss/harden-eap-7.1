#!/bin/bash

. `dirname $0`/demo.conf

rm -fr ${WORK_DIR}/jboss-eap-${VER_INST_EAP} \
    ~/java.security.properties ~/fipsdb ~/nss-pkcs11-fips.cfg

