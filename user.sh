

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y

useradd roboshop

rm -rf /app
mkdir /app

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

unzip /tmp/user.zip

npm install

cp /home/centos/roboshop_shell1/user.service /etc/systemd/system/user.service

systemctl daemon-reload

systemctl enable user
systemctl start user

cp /home/centos/roboshop_shell1/mongod.repo /etc/yum.repos.d/mongod.repo

yum install mongodb-org-shell -y

mongo --host mongodb-dev.rpadaladevops.online </app/schema/user.js

systemctl restart mongod
systemctl restart user