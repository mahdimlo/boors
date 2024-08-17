FROM bde2020/hadoop-namenode:2.0.0-hadoop3.2.1-java8

RUN sed -i 's/stretch/buster/g' /etc/apt/sources.list && \
    apt update && \
    apt install -y krb5-kdc krb5-admin-server

COPY ./namenode_config/hdfs-site.xml /etc/hadoop/hdfs-site.xml
COPY ./namenode_config/core-site.xml /etc/hadoop/core-site.xml
COPY ./kerberos_config/krb5.conf /etc/krb5.conf
COPY ./kerberos_config/kdc.conf /etc/krb5kdc/kdc.conf
COPY ./kerberos_config/kadm5.acl /etc/krb5kdc/kadm5.acl

ENV USER_OWN=mahdi
ENV USER_TOW=vahid
ENV USER_ADMIN=admin

ENV PASS_OWN=123456789
ENV PASS_TOW=123456789
ENV PASS_ADMIN=123456789

RUN useradd -m -u 1000 -s /bin/bash $USER_OWN && \
    useradd -m -u 1500 -s /bin/bash $USER_TOW && \
    useradd -m -u 2000 -s /bin/bash $USER_ADMIN

COPY setup-hdfs.sh /setup-hdfs.sh
RUN chmod +x /setup-hdfs.sh

CMD ["/setup-hdfs.sh"]
