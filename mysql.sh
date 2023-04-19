script_path=$(dirname $0)
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>>>>>> DISABLE MYSQL 8 >>>>>>>>>>>>\e[0m"
dnf module disable mysql -y

echo -e "\e[36m>>>>>>>>>>>>>>> COPY REPO FILE TO YUM.REPO.D >>>>>>>>>>>>\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL MYSQL >>>>>>>>>>>>\e[0m"
yum install mysql-community-server -y

echo -e "\e[36m>>>>>>>>>>>>>>> ENABLE THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl enable mysqld

echo -e "\e[36m>>>>>>>>>>>>>>> RESTART THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl start mysqld

echo -e "\e[36m>>>>>>>>>>>>>>> SET MYSQL PASSWORD >>>>>>>>>>>>\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1

mysql -uroot -pRoboShop@1