FROM bde2020/hadoop-namenode:2.0.0-hadoop3.2.1-java8

COPY ./hdfs-site.xml /etc/hadoop/hdfs-site.xml

ENV USER_OWN=mahdi
ENV USER_TOW=vahid
ENV USER_ADMIN=admin

RUN useradd -m -u 1000 -s /bin/bash $USER_OWN && \
    useradd -m -u 1500 -s /bin/bash $USER_TOW && \
    useradd -m -u 2000 -s /bin/bash $USER_ADMIN

COPY setup-hdfs.sh /setup-hdfs.sh
RUN chmod +x /setup-hdfs.sh

CMD ["/setup-hdfs.sh"]
