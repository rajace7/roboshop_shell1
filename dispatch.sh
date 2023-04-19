source common.sh

echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL GOLANG >>>>>>>>>>>>\e[0m"
yum install golang -y

echo -e "\e[36m>>>>>>>>>>>>>>> ADD APPLICATION USER >>>>>>>>>>>>\e[0m"
useradd ${application_user}

echo -e "\e[36m>>>>>>>>>>>>>>> CREATE APP DIRECTORY >>>>>>>>>>>>\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>> DOWNLOAD THE APPLCATION CONTENT >>>>>>>>>>>>\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>> UNZIP APPLICATION CONTENT >>>>>>>>>>>>\e[0m"
unzip /tmp/dispatch.zip

echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL THE DEPENDENCIES >>>>>>>>>>>>\e[0m"
go mod init dispatch
go get
go build

echo -e "\e[36m>>>>>>>>>>>>>>> COPY SERVICE FILE TO SYSTEMD >>>>>>>>>>>>\e[0m"
cp /home/centos/roboshop_shell1/dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[36m>>>>>>>>>>>>>>> RELOAD THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl daemon-reload

echo -e "\e[36m>>>>>>>>>>>>>>> ENABLE THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl enable dispatch

echo -e "\e[36m>>>>>>>>>>>>>>> RESTART THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl restart dispatch