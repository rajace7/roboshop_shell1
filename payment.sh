
echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL PYTHON 3.6 >>>>>>>>>>>>\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[36m>>>>>>>>>>>>>>> ADD APPLICATION USER >>>>>>>>>>>>\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>>>>>>> CREATE APP DIRECTORY >>>>>>>>>>>>\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>> DOWNLOAD THE APPLCATION CONTENT >>>>>>>>>>>>\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>> UNZIP APPLICATION CONTENT >>>>>>>>>>>>\e[0m"
unzip /tmp/payment.zip

echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL THE DEPENDENCIES >>>>>>>>>>>>\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[36m>>>>>>>>>>>>>>> COPY SERVICE FILE TO SYSTEMD >>>>>>>>>>>>\e[0m"
cp /home/centos/roboshop_shell1/payment.service /etc/systemd/system/payment.service

echo -e "\e[36m>>>>>>>>>>>>>>> RELOAD THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl daemon-reload

echo -e "\e[36m>>>>>>>>>>>>>>> ENABLE THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl enable payment

echo -e "\e[36m>>>>>>>>>>>>>>> RESTART THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl restart payment

