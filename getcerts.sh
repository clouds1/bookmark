#!/bin/bash

# LDAP server hostname and port
LDAPS_SERVER="your-ldaps-server"
LDAPS_PORT="636"

# Name for the certificate file
CERT_CHAIN="cert_chain.pem"

# Connect to the LDAPS server and retrieve certificates
openssl s_client -showcerts -connect $LDAPS_SERVER:$LDAPS_PORT </dev/null | awk '/-----BEGIN CERTIFICATE-----/, /-----END CERTIFICATE-----/' > $CERT_CHAIN

# Extract and import individual certificates
CERT_COUNTER=1
while true; do
  CERT_FILE="cert$CERT_COUNTER.crt"
  awk -v c=$CERT_COUNTER '/-----BEGIN CERTIFICATE-----/, /-----END CERTIFICATE-----/ {print $0 > "'$CERT_FILE'"} /-----END CERTIFICATE-----/ {c++;}' $CERT_CHAIN
  if [ -s "$CERT_FILE" ]; then
    keytool -import -noprompt -alias cert$CERT_COUNTER -file $CERT_FILE -keystore truststore.jks -storepass your-password
    rm $CERT_FILE
    CERT_COUNTER=$((CERT_COUNTER + 1))
  else
    break
  fi
done

# Clean up the certificate chain file
rm $CERT_CHAIN
