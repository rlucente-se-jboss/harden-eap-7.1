Install RHEL 7.4 and put it into FIPS mode, following these
[instructions](https://github.com/rlucente-se-jboss/intranet-test-certs).
Make sure to provide the needed certificates and keys to the
unprivileged user directory that will be installing JBoss EAP 7.1.
As root, do the following to make the certificates available:

    cd /root
    cp *.p12 ~jboss
    chown jboss:jboss ~jboss/*

Those commands assume that the unprivileged user name is `jboss`.

## Configure security database
Login as an unprivileged user and run the following commands:

    mkdir ~/eap-demo
    cd ~/eap-demo
    
Copy all of the files here to that directory.  Also, make sure that
the `dist` directory has the file `jboss-eap-7.1.0.zip`.  Then run
the following commands:

    ./01-clean.sh
    ./02-create-java-security-overrides.sh
    ./03-create-nss-db.sh
    ./04-install.sh
    ./05-create-credentialstore.sh
    ./06-configure-tls.sh
    ./07-secure-management-interface.sh

