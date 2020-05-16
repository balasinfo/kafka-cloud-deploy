#!/bin/bash
set -ex
# Script to start a zookeeper Docker container
#exec > >(tee /var/log/user-data.log|logger -t setup-zookeeper -s 2>/dev/console) 2>&1

# unload command line
id=$1

# create an array of IPs
ip_addrs=( ${ip_addrs} )


# update java
sudo yum remove -y java-1.7.0-openjdk
sudo yum install -y java-1.8.0

# create zookeeper user
mkdir -p /opt/zookeeper
if ! id zookeeper 2> /dev/null; then
    useradd -d /opt/zookeeper zookeeper
fi

touch /zookeeper_server.pid
chown -R zookeeper:zookeeper /zookeeper_server.pid

# download zookeeper
version_name=zookeeper-${version}
base_name=apache-$version_name-bin
cd /tmp
curl --connect-timeout 5 \
    --max-time 10 \
    --retry 10 \
    --retry-delay 3 \
    --retry-max-time 140 \
    -o $base_name.tar.gz ${repo}/$version_name/$base_name.tar.gz

# unpack the tarball
cd /opt/zookeeper
tar xzf /tmp/$base_name.tar.gz
pwd
#rm /tmp/$base_name.tar.gz
cd $base_name

# create a data dir
mkdir -p /var/lib/zookeeper

# configure the server
cat conf/zoo_sample.cfg \
    | sed 's|dataDir=/tmp/zookeeper|dataDir=/var/lib/zookeeper|' \
    > /tmp/zoo.cfg
echo "# server list" >> /tmp/zoo.cfg
for i in {1..${count}}; do
    echo "server.$i=$${ip_addrs[$((i-1))]}:2888:3888" >> /tmp/zoo.cfg
done
mv /tmp/zoo.cfg conf/zoo.cfg

# configure the logging
cat conf/log4j.properties \
    | sed 's/zookeeper.root.logger=INFO, CONSOLE/zookeeper.root.logger=INFO/' \
    > /tmp/log4j.properties
mv /tmp/log4j.properties conf/log4j.properties

# set the ID
echo $id > /var/lib/zookeeper/myid

# change ownership
chown -R zookeeper:zookeeper /opt/zookeeper
chown -R zookeeper:zookeeper /var/lib/zookeeper
