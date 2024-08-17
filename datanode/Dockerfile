FROM bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8

RUN RUN sed -i 's/stretch/buster/g' /etc/apt/sources.list && \
    apt update && \
    apt install -y krb5-user krb5-config

COPY ./namenode_config/hdfs-site.xml /etc/hadoop/hdfs-site.xml
COPY ./namenode_config/core-site.xml /etc/hadoop/core-site.xml
COPY ./kerberos_config/krb5.conf /etc/krb5.conf
COPY ./kerberos_config/kdc.conf /etc/krb5kdc/kdc.conf
COPY ./kerberos_config/kadm5.acl /etc/krb5kdc/kadm5.acl
COPY setup-datanode.sh /setup-datanode.sh

RUN chmod +x /setup-datanode.sh

CMD ["/setup-datanode.sh"]