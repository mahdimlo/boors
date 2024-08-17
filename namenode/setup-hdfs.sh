#!/bin/bash

/usr/sbin/krb5kdc &
/usr/sbin/kadmind &

kadmin.local -q "addprinc -pw $PASS_ONE $USER_OWN@BOORS.LOCAL"
kadmin.local -q "addprinc -pw $PASS_TOW $USER_TOW@BOORS.LOCAL"
kadmin.local -q "addprinc -pw $PASS_ADMIN $USER_ADMIN/admin@BOORS.LOCAL"

kadmin.local -q "addprinc -randkey hdfs/namenode@BOORS.LOCAL"
kadmin.local -q "addprinc -randkey hdfs/datanode@BOORS.LOCAL"

kadmin.local -q "ktadd -k /etc/security/keytabs/nn.service.keytab hdfs/namenode@BOORS.LOCAL"
kadmin.local -q "ktadd -k /etc/security/keytabs/dn.service.keytab hdfs/datanode@BOORS.LOCAL"
kadmin.local -q "ktadd -k /etc/security/keytabs/spnego.service.keytab HTTP/namenode@BOORS.LOCAL"

for USER in $USER_OWN $USER_TOW $USER_ADMIN; do
    echo "export HADOOP_HOME=$HADOOP_HOME" >> /home/$USER/.bashrc
    echo "export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin" >> /home/$USER/.bashrc
done

source /home/$USER_OWN/.bashrc
source /home/$USER_TOW/.bashrc
source /home/$USER_ADMIN/.bashrc

NAMENODE_DIR="/hadoop/dfs/name/current"

if [ ! -d "$NAMENODE_DIR" ]; then
    echo "Formatting NameNode as it is not yet formatted."
    hdfs namenode -format -force -nonInteractive
else
    echo "NameNode is already formatted. Skipping format."
fi

hadoop namenode &

until hdfs dfs -ls / > /dev/null 2>&1; do
    echo "Waiting for NameNode to start..."
    sleep 5
done

echo "Successfully connected to HDFS."

hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/$USER_OWN
hdfs dfs -mkdir /user/$USER_TOW
hdfs dfs -mkdir /user/$USER_ADMIN

hdfs dfs -chown $USER_ADMIN /user
hdfs dfs -chown $USER_OWN /user/$USER_OWN
hdfs dfs -chown $USER_TOW /user/$USER_TOW
hdfs dfs -chown $USER_ADMIN /user/$USER_ADMIN

hdfs dfs -setfacl -R -m user:$USER_ADMIN:rwx /user
hdfs dfs -setfacl -R -m user:$USER_ADMIN:rwx /user/$USER_ADMIN
hdfs dfs -setfacl -R -m user:$USER_OWN:rwx /user/$USER_OWN
hdfs dfs -setfacl -R -m user:$USER_TOW:rwx /user/$USER_TOW

hdfs dfs -setfacl -R -m other::--x /user
hdfs dfs -setfacl -R -m group::--x /user

hdfs dfs -setfacl -R -m other::--- /user/$USER_OWN
hdfs dfs -setfacl -R -m other::--- /user/$USER_TOW
hdfs dfs -setfacl -R -m other::--- /user/$USER_ADMIN

hdfs dfs -setfacl -R -m group::--- /user/$USER_OWN
hdfs dfs -setfacl -R -m group::--- /user/$USER_TOW
hdfs dfs -setfacl -R -m group::--- /user/$USER_ADMIN

kill %1
hadoop namenode