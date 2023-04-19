
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y

useradd roboshop

rm -rf /app
mkdir /app

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

unzip /tmp/catalogue.zip

npm install

cp /home/centos/roboshop_shell1/catalogue.service /etc/systemd/system/catalogue.service

systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue


cp /home/centos/roboshop_shell1/mongod.repo /etc/yum.repos.d/mongod.repo

yum install mongodb-org-shell -y

mongo --host mongodb-dev.rpadaladevops.online </app/schema/catalogue.js

systemctl restart mongod