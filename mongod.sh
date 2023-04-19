
cp mongod.repo /etc/yum.repos.d/mongod.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod

netstat -lntp

sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf

systemctl restart mongod

netstat -lntp