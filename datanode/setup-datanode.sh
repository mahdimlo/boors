#!/bin/bash

sleep 10
/usr/sbin/krb5kdc &
/usr/sbin/kadmind &

kadmin.local -q "addprinc -randkey hdfs/datanode@BOORS.LOCAL"
kadmin.local -q "ktadd -k /etc/security/keytabs/dn.service.keytab hdfs/datanode@BOORS.LOCAL"

kinit -kt /etc/security/keytabs/dn.service.keytab hdfs/datanode@BOORS.LOCAL

echo "export HADOOP_HOME=$HADOOP_HOME" >> /etc/profile
echo "export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin" >> /etc/profile
echo "export KRB5_CONFIG=/etc/krb5.conf" >> /etc/profile
echo "export HADOOP_OPTS=\"-Djava.security.krb5.conf=/etc/krb5.conf\"" >> /etc/profile

source /etc/profile

hdfs datanode
