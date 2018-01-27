#!/bin/bash

: ${HADOOP_HOME:=/hadoop/hadoop}

$HADOOP_HOME/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_HOME/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# altering the core-site configuration
#sed s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml
#sed -i "s/master/$HOSTNAME/" /hadoop/hadoop/etc/hadoop/core-site.xml


service ssh start
echo "127.0.0.1 master" >> /etc/hosts 
printf "Host master\n\tStrictHostKeyChecking no\n\t UserKnownHostsFile=/dev/null\n Host localhost\n\tStrictHostKeyChecking no\n\t UserKnownHostsFile=/dev/null\nHost 0.0.0.0\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config
$HADOOP_HOME/bin/hdfs namenode -format
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager
$HADOOP_HOME/sbin/yarn-daemon.sh start resourcemanager


#$HADOOP_HOME/bin/hdfs dfs -mkdir /hw2

#$HADOOP_HOME/bin/hdfs dfs -mkdir /input

#echo  "hello hello  hi hi hi " >> $HADOOP_HOME/bin/input1.txt

#$HADOOP_HOME/bin/hdfs dfs -copyFromLocal $HADOOP_HOME/bin/input1.txt  /wordcount/input/input1.txt

$HADOOP_HOME/bin/hadoop fs -copyFromLocal $HADOOP_HOME/input /

$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME/mapreduce-all.jar /input output

$HADOOP_HOME/bin/hdfs dfs -cat /user/root/output/final/part-r-00000

#if [[ $1 == "-d" ]]; then
#  while true; do sleep 1000; done
#fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
