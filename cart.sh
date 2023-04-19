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
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>> UNZIP APPLICATION CONTENT >>>>>>>>>>>>\e[0m"
unzip /tmp/cart.zip

echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL THE DEPENDENCIES >>>>>>>>>>>>\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>>>>>>> COPY SERVICE FILE TO SYSTEMD >>>>>>>>>>>>\e[0m"
cp /home/centos/roboshop_shell1/cart.service /etc/systemd/system/cart.service

echo -e "\e[36m>>>>>>>>>>>>>>> RELOAD THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl daemon-reload

echo -e "\e[36m>>>>>>>>>>>>>>> ENABLE THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl enable cart

echo -e "\e[36m>>>>>>>>>>>>>>> RESTART THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl restart cart
