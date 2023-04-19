source common.sh

echo -e "\e[36m>>>>>>>>>>>>>>> CONFIGURE NODE JS REPO >>>>>>>>>>>>\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL NODE JS >>>>>>>>>>>>\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>>>>>>>>> ADD APPLICATION USER >>>>>>>>>>>>\e[0m"
useradd ${application_user}

echo -e "\e[36m>>>>>>>>>>>>>>> CREATE APP DIRECTORY >>>>>>>>>>>>\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>> DOWNLOAD THE APPLCATION CONTENT >>>>>>>>>>>>\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>> UNZIP APPLICATION CONTENT >>>>>>>>>>>>\e[0m"
unzip /tmp/user.zip

echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL THE DEPENDENCIES >>>>>>>>>>>>\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>>>>>>> COPY SERVICE FILE TO SYSTEMD >>>>>>>>>>>>\e[0m"
cp /home/centos/roboshop_shell1/user.service /etc/systemd/system/user.service

echo -e "\e[36m>>>>>>>>>>>>>>> RELOAD THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl daemon-reload

echo -e "\e[36m>>>>>>>>>>>>>>> ENABLE THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl enable user

echo -e "\e[36m>>>>>>>>>>>>>>> RESTART THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl start user

echo -e "\e[36m>>>>>>>>>>>>>>> COPY REPO FILE TO YUM.REPO.D >>>>>>>>>>>>\e[0m"
cp /home/centos/roboshop_shell1/mongod.repo /etc/yum.repos.d/mongod.repo

echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL MONGOD CLIENT >>>>>>>>>>>>\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>>>>>>> LOAD THE SCEHMA >>>>>>>>>>>>\e[0m"
mongo --host mongodb-dev.rpadaladevops.online </app/schema/user.js

echo -e "\e[36m>>>>>>>>>>>>>>> RESTART THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl restart user