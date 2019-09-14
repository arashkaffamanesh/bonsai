#!/bin/bash

# Root pair
mkdir /root/ca
cd /root/ca
mkdir certs crl newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial

wget -O /root/ca/openssl.cnf https://jamielinux.com/docs/openssl-certificate-authority/_downloads/root-config.txt

echo "##########"
echo "CREATE root key"
echo "##########"
openssl genrsa -aes256 -out private/ca.key.pem 4096
chmod 400 private/ca.key.pem

echo "##########"
echo "CREATE root certificate"
echo "Fill in the Common Name!"
echo "##########"
openssl req -config openssl.cnf \
      -key private/ca.key.pem \
      -new -x509 -days 7300 -sha256 -extensions v3_ca \
      -out certs/ca.cert.pem
      
chmod 444 certs/ca.cert.pem

# Intermediate
mkdir /root/ca/intermediate
cd /root/ca/intermediate
mkdir certs crl csr newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial
echo 1000 > /root/ca/intermediate/crlnumber

wget -O /root/ca/intermediate/openssl.cnf https://jamielinux.com/docs/openssl-certificate-authority/_downloads/intermediate-config.txt
echo "##########"
echo "KEY intermediate"
echo "##########"
cd /root/ca
openssl genrsa -aes256 \
      -out intermediate/private/intermediate.key.pem 4096
chmod 400 intermediate/private/intermediate.key.pem

echo "##########"
echo "CSR intermediate"
echo "Fill in the Common Name!"
echo "##########"
openssl req -config intermediate/openssl.cnf -new -sha256 \
      -key intermediate/private/intermediate.key.pem \
      -out intermediate/csr/intermediate.csr.pem

echo "##########"
echo "SIGN intermediate"
echo "##########"
openssl ca -config openssl.cnf -extensions v3_intermediate_ca \
      -days 3650 -notext -md sha256 \
      -in intermediate/csr/intermediate.csr.pem \
      -out intermediate/certs/intermediate.cert.pem
      
chmod 444 intermediate/certs/intermediate.cert.pem

cat intermediate/certs/intermediate.cert.pem \
      certs/ca.cert.pem > intermediate/certs/ca-chain.cert.pem
chmod 444 intermediate/certs/ca-chain.cert.pem

echo "##########"
echo "KEY certificate"
echo "##########"
openssl genrsa -aes256 \
      -out intermediate/private/node2.key.pem 2048
chmod 400 intermediate/private/node2.key.pem

echo "##########"
echo "CSR certificate"
echo "Use node2 as Common Name"
echo "##########"
openssl req -config intermediate/openssl.cnf \
      -key intermediate/private/node2.key.pem \
      -new -sha256 -out intermediate/csr/node2.csr.pem
      
echo "##########"
echo "SIGN certificate"
echo "##########"
openssl ca -config intermediate/openssl.cnf \
      -extensions server_cert -days 375 -notext -md sha256 \
      -in intermediate/csr/node2.csr.pem \
      -out intermediate/certs/node2.cert.pem
chmod 444 intermediate/certs/node2.cert.pem

echo "##########"
echo "Create files to be used for Rancher"
echo "##########"
mkdir -p /root/ca/rancher/base64
cp /root/ca/certs/ca.cert.pem /root/ca/rancher/cacerts.pem
cat /root/ca/intermediate/certs/node2.cert.pem /root/ca/intermediate/certs/intermediate.cert.pem > /root/ca/rancher/cert.pem
echo "##########"
echo "Removing passphrase from Rancher certificate key"
echo "##########"
openssl rsa -in /root/ca/intermediate/private/node2.key.pem -out /root/ca/rancher/key.pem
cat /root/ca/rancher/cacerts.pem | base64 -w0 > /root/ca/rancher/base64/cacerts.base64
cat /root/ca/rancher/cert.pem | base64 -w0 > /root/ca/rancher/base64/cert.base64
cat /root/ca/rancher/key.pem | base64 -w0 > /root/ca/rancher/base64/key.base64

echo "##########"
echo "Verify certificates"
echo "##########"
openssl verify -CAfile certs/ca.cert.pem \
      intermediate/certs/intermediate.cert.pem
openssl verify -CAfile intermediate/certs/ca-chain.cert.pem \
      intermediate/certs/node2.cert.pem