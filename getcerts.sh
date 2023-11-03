#!/bin/bash

# LDAP server hostname and port
LDAPS_SERVER="your-ldaps-server"
LDAPS_PORT="636"

# Connect to the LDAPS server and retrieve certificates
cert_chain=$(openssl s_client -showcerts -connect $LDAPS_SERVER:$LDAPS_PORT </dev/null)

# Separate certificates and save them individually
cert_counter=0
while read -r cert; do
  if [[ "$cert" == "-----END CERTIFICATE-----" ]]; then
    cert_counter=$((cert_counter + 1))
  fi
  echo "$cert" >> "cert$cert_counter.crt"
done <<< "$cert_chain"

# Import individual certificates into the Java Truststore
truststore="truststore.jks"
password="your-password"

for ((i = 0; i <= cert_counter; i++)); do
  cert_file="cert$i.crt"
  if [ -s "$cert_file" ]; then
    keytool -import -noprompt -alias cert$i -file "$cert_file" -keystore "$truststore" -storepass "$password"
    rm "$cert_file"
  fi
done

