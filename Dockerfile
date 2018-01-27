from armv7/armhf-ubuntu
USER root
RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y curl nano tar sudo openssh-server openssh-client rsync libselinux1

RUN apt-get update    
RUN mkdir /hadoop
RUN mkdir /hadoop_tmp

#yes y |ssh-keygen -q -t rsa -N '' >/dev/null

RUN yes y | ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN yes y | ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN yes y | ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

RUN apt-get --assume-yes install openjdk-8-jdk


ENV HADOOP_HOME /hadoop/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
ENV PATH $PATH:$HADOOP_HOME/sbin
#ENV HADOOP_MAPRED_HOME $HADOOP_HOME
#ENV HADOOP_COMMON_HOME $HADOOP_HOME
#ENV HADOOP_HDFS_HOME $HADOOP_HOME
#ENV YARN_HOME $HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR $HADOOP_HOME/lib/native
ENV HADOOP_OPTS "-Djava.library.path=$HADOOP_HOME/lib"
#ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-armhf/jre

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-armhf
#ENV HADOOP_HOME /hadoop/hadoop
ENV HADOOP_PREFIX $HADOOP_HOME
ENV HADOOP_COMMON_HOME /hadoop/hadoop
ENV HADOOP_HDFS_HOME /hadoop/hadoop
ENV HADOOP_MAPRED_HOME /hadoop/hadoop
ENV HADOOP_YARN_HOME /hadoop/hadoop
ENV HADOOP_CONF_DIR /hadoop/hadoop/etc/hadoop
ENV YARN_CONF_DIR /hadoop/hadoop/etc/hadoop
ENV HADOOP_CLASSPATH /usr/lib/jvm/java-1.8.0-openjdk-armhf/lib/tools.jar
ENV YARN_LOG_DIR /hadoop/hadoop/logs



RUN cd /hadoop
#RUN ls
#RUN wget http://www.us.apache.org/dist/hadoop/common/hadoop-2.8.2/hadoop-2.8.2.tar.gz
#RUN curl -s http://www.eu.apache.org/dist/hadoop/common/hadoop-2.8.2/hadoop-2.8.2.tar.gz | tar -xz -C /usr/local/
#RUN wget http://www.eu.apache.org/dist/hadoop/common/hadoop-2.8.2/hadoop-2.8.2.tar.gz | tar -xz -C /usr/local/
#RUN curl -s https://www.us.apache.org/dist/hadoop/common/hadoop-2.8.2/hadoop-2.8.2.tar.gz

RUN curl -s http://www.eu.apache.org/dist/hadoop/common/hadoop-2.8.2/hadoop-2.8.2.tar.gz | tar -xz -C /hadoop
RUN cd /hadoop && ln -s ./hadoop-2.8.2 hadoop

RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-armhf"\nexport HADOOP_PREFIX="/hadoop/hadoop"\nexport HADOOP_HOME="/hadoop/hadoop"\nexport HADOOP_COMMON_HOME="/hadoop/hadoop"\nexport HADOOP_HDFS_HOME="/hadoop/hadoop"\nexport HADOOP_MAPRED_HOME="/hadoop/hadoop"\nexport HADOOP_YARN_HOME="/hadoop/hadoop"\nexport HADOOP_CONF_DIR="/hadoop/hadoop/etc/hadoop"\nexport YARN_CONF_DIR="/hadoop/hadoop/etc/hadoop"\nexport HADOOP_CLASSPATH="/usr/lib/jvm/java-1.8.0-openjdk-armhf/lib/tools.jar"\nexport YARN_LOG_DIR="/hadoop/hadoop/logs":' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
#RUN sed -i '\^export YARN_LOG_DIR=\"/hadoop/hadoop/logs\":' $HADOOP_HOME/etc/hadoop/yarn-env.sh
RUN echo "export YARN_LOG_DIR=\"/hadoop/hadoop/logs\"\n$(cat /hadoop/hadoop/etc/hadoop/yarn-env.sh)" > $HADOOP_HOME/etc/hadoop/yarn-env.sh
#RUN tar xvf hadoop-2.8.2.tar.gz
#RUN mv hadoop-2.8.2 hadoop
#RUN cd /usr/local && ln -s ./hadoop-2.8.2 hadoop
RUN echo >> 'master' $HADOOP_HOME/hadoop/etc/hadoop/master
RUN mkdir /hadoop_tmp/hdfs
RUN mkdir /hadoop_tmp/hdfs/namenode
COPY core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
COPY mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml

RUN mkdir $HADOOP_HOME/input
COPY input/ $HADOOP_HOME/input/
COPY mapreduce-all.jar $HADOOP_HOME
 
#RUN cat find / -name “start-yarn.sh”
#RUN bash start-yarn.sh 
#RUN find . -type d -exec ./start-dfs.sh {} \;
#RUN $HADOOP_HOME/hadoop/bin/start-yarn.sh
#RUN $HADOOP_HOME/hadoop/bin/start-dfs.sh
#RUN $HADOOP_HOME/bin/hdfs namenode -format

RUN chown -R root /hadoop/hadoop
RUN chmod 700 /hadoop/hadoop
#RUN start-dfs.sh
ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh
ENV BOOTSTRAP /etc/bootstrap.sh

CMD ["/etc/bootstrap.sh", "-d"]
EXPOSE 50020 50090 50070 50010 50075 8031 8032 8033 8040 8042 49707 22 8088 8030
