script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL NGINX WEBSERVER>>>>>>>>>>>>\e[0m"
yum install nginx -y

echo -e "\e[36m>>>>>>>>>>>>>>> ENABLE NGINX WEBSERVER >>>>>>>>>>>>\e[0m"
systemctl enable nginx

echo -e "\e[36m>>>>>>>>>>>>>>> RESTART NGINX WEBSERVER >>>>>>>>>>>>\e[0m"
systemctl start nginx

echo -e "\e[36m>>>>>>>>>>>>>>> REMOVE DEFAULT CONTENT ON WEBSERVER>>>>>>>>>>>>\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[36m>>>>>>>>>>>>>>> DOWNLOAD THE APP CONTENT >>>>>>>>>>>>\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

cd /usr/share/nginx/html

echo -e "\e[36m>>>>>>>>>>>>>>> UNZIP THE APP CONTENT >>>>>>>>>>>>\e[0m"
unzip /tmp/frontend.zip

echo -e "\e[36m>>>>>>>>>>>>>>> COPY REVERSE PROXY FILE TO DEFAULT.D FOLDER >>>>>>>>>>>>\e[0m"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m>>>>>>>>>>>>>>> RESTART NGINX WEBSERVER >>>>>>>>>>>>\e[0m"
systemctl restart nginx